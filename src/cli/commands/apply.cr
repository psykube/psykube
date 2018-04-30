require "./concerns/*"

class Psykube::CLI::Commands::Apply < Admiral::Command
  include Kubectl
  include KubectlAll
  include Docker

  define_flag push : Bool, description: "Don't build and push the docker image.", default: true
  define_flag image, description: "Override the generated docker image."
  define_flag wait : Bool, description: "Don't wait for the rollout.", default: true
  define_flag tag, description: "The docker tag to apply.", short: t
  define_flag force : Bool, description: "Force the recreation of the kubernetes resources."
  define_flag create_namespace : Bool, description: "create the namespace before the given apply"

  define_help description: "Apply the kubernetes manifests."

  def run
    kubectl_create_namespace(namespace) if flags.create_namespace
    docker_build_and_push(actor.buildable_contexts) if !flags.tag && !flags.image && flags.push
    result = actor.generate
    puts "Applying Kubernetes Manifests...".colorize(:cyan)
    result.items.not_nil!.each do |item|
      force = flags.force
      if item.is_a?(Pyrite::Api::Core::V1::Service) && (service = Pyrite::Api::Core::V1::Service.from_json(kubectl_json(manifest: item, panic: false, error: false)) rescue nil)
        item.metadata.not_nil!.resource_version = service.metadata.not_nil!.resource_version
      end
      kubectl_run("apply", manifest: item, flags: {"--record" => !force, "--force" => force})
    end
    if actor.manifest.type == "Deployment" && flags.wait
      kubectl_run("rollout", ["status", "#{actor.manifest.type}/#{actor.manifest.name}".downcase])
    end
    kubectl_run("annotate", ["namespace", namespace, "psykube.io/last-modified=#{Time.now.to_json}"], flags: {"--overwrite" => "true"})
  end
end
