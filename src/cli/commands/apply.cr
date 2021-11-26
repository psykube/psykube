require "./concerns/*"

class Psykube::CLI::Commands::Apply < Admiral::Command
  include Kubectl
  include KubectlAll
  include Docker

  define_flag build : Bool, description: "Don't build the docker image.", default: !Bool.from_yaml(ENV["PSYKUBE_NO_BUILD"]? || "false")
  define_flag push : Bool, description: "Don't push the docker image.", default: !Bool.from_yaml(ENV["PSYKUBE_NO_PUSH"]? || "false")
  define_flag current_image : Bool, description: "Use the currently deployed image."
  define_flag image, description: "Override the generated docker image."
  define_flag wait : Bool, description: "Don't wait for the rollout.", default: !Bool.from_yaml(ENV["PSYKUBE_NO_WAIT"]? || "false")
  define_flag restart : Bool, description: "Restart the deployment after the apply.", default: false
  define_flag tag, description: "The docker tag to apply.", short: t
  define_flag force : Bool, description: "Force the recreation of the kubernetes resources."
  define_flag create_namespace : Bool, description: "create the namespace before the given apply."
  define_flag skip_if_no_cluster : Bool, description: "dont fail, just skip the apply if the cluster does not exist."

  define_help description: "Apply the kubernetes manifests."

  def run
    if (actor.clusters.empty? || !actor.cluster.initialized?)
      kubectl_create_namespace(namespace) if flags.create_namespace

      # Build the image
      if !flags.tag && !flags.image && flags.build
        docker_build(actor.buildable_contexts)
      elsif flags.current_image
        set_images_from_current!
      end

      # Push the image
      if !flags.tag && !flags.image && flags.build && flags.push
        docker_push(actor.buildable_contexts)
      end

      result = actor.generate
      puts "Applying Kubernetes Manifests...".colorize(:cyan)
      result.items.not_nil!.each do |item|
        force = flags.force
        if item.is_a?(Pyrite::Api::Core::V1::Service) && (service = Pyrite::Api::Core::V1::Service.from_json(kubectl_json(manifest: item, panic: false, error: false)) rescue nil)
          item.metadata.not_nil!.resource_version = service.metadata.not_nil!.resource_version
        end
        kubectl_run("apply", manifest: item, flags: {"--force" => force})
      end
      if ["Deployment", "StatefulSet", "DaemonSet"].includes?(actor.manifest.type) && flags.restart
        kubectl_run("rollout", ["restart", "#{actor.manifest.type}/#{actor.name}".downcase])
      end
      if ["Deployment", "StatefulSet", "DaemonSet"].includes?(actor.manifest.type) && flags.wait
        kubectl_run("rollout", ["status", "#{actor.manifest.type}/#{actor.name}".downcase])
      end
      kubectl_run("annotate", ["namespace", namespace, "psykube.io/last-modified=#{Time.utc.to_json}"], flags: {"--overwrite" => "true"})
    elsif flags.skip_if_no_cluster
      @error_io.puts "cluster not defined: `#{actor.cluster_name}`, skipping...".colorize(:yellow)
    else
      raise Error.new "cluster not defined: `#{actor.cluster_name}`"
    end
  end
end
