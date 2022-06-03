require "./concerns/*"

class Psykube::CLI::Commands::Apply < Admiral::Command
  include Kubectl
  include KubectlAll
  include Docker

  @items : Array(Pyrite::Kubernetes::Resource)?

  define_flag build : Bool, description: "Don't build the docker image.", default: !Bool.from_yaml(ENV["PSYKUBE_NO_BUILD"]? || "false")
  define_flag push : Bool, description: "Don't push the docker image.", default: !Bool.from_yaml(ENV["PSYKUBE_NO_PUSH"]? || "false")
  define_flag current_image : Bool, description: "Use the currently deployed image."
  define_flag image, description: "Override the generated docker image."
  define_flag wait : Bool, description: "Don't wait for the rollout.", default: !Bool.from_yaml(ENV["PSYKUBE_NO_WAIT"]? || "false")
  define_flag require_pinned : Bool, description: "Require pinned images.", default: !Bool.from_yaml(ENV["PSYKUBE_REQUIRE_PINNED"]? || "false")
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
      if !flags.tag && !flags.image && (flags.build || flags.push)
        docker_build(actor.buildable_contexts)
        # Push the image
        if !flags.tag && !flags.image && flags.build && flags.push
          docker_push(actor.buildable_contexts)
        end
      elsif flags.current_image
        set_images_from_current!
      end

      verify_pinned! if flags.require_pinned
      apply!
      restart! if ["Deployment", "StatefulSet", "DaemonSet"].includes?(actor.manifest.type) && flags.restart
      wait! if ["Deployment", "StatefulSet", "DaemonSet"].includes?(actor.manifest.type) && flags.wait
      annotate!
    elsif flags.skip_if_no_cluster
      @error_io.puts "cluster not defined: `#{actor.cluster_name}`, skipping...".colorize(:yellow)
    else
      raise Error.new "cluster not defined: `#{actor.cluster_name}`"
    end
  end

  def verify_pinned!
    puts "Verifying pinned images...".colorize(:cyan)
    unless untagged_images.empty?
      raise Error.new "images must be pinned when setting --require-pinned: #{untagged_images.map(&.image).join(", ")}"
    end
  end

  def untagged_images
    (actor.build_contexts + actor.init_build_contexts).reject(&.has_tag?)
  end

  def apply!
    puts "Applying Kubernetes Manifests...".colorize(:cyan)
    items.not_nil!.each do |item|
      force = flags.force
      if item.is_a?(Pyrite::Api::Core::V1::Service) && (service = Pyrite::Api::Core::V1::Service.from_json(kubectl_json(manifest: item, panic: false, error: false)) rescue nil)
        item.metadata.not_nil!.resource_version = service.metadata.not_nil!.resource_version
      end
      kubectl_run("apply", manifest: item, flags: {"--force" => force}, panic: !item.is_a?(Pyrite::Kubernetes::CustomObject))
    end
  end

  def restart!
    puts "Restarting #{actor.manifest.type}...".colorize(:cyan)
    kubectl_run("rollout", ["restart", "#{actor.manifest.type}/#{actor.name}".downcase])
  end

  def wait!
    puts "Waiting for #{actor.manifest.type}...".colorize(:cyan)
    kubectl_run("rollout", ["status", "#{actor.manifest.type}/#{actor.name}".downcase])
  end

  def annotate!
    kubectl_run("annotate", ["namespace", namespace, "psykube.io/last-modified=#{Time.utc.to_json}"], flags: {"--overwrite" => "true"})
  end

  def items
    @items ||= actor.generate.items
  end
end
