require "admiral"
require "./concerns/*"

class Psykube::Commands::Apply < Admiral::Command
  include Docker
  include Kubectl
  include KubectlAll

  define_help description: "Apply the kubernetes manifests."

  define_flag copy_namespace, description: CopyNamespace::DESCRIPTION
  define_flag push : Bool, description: "Build and push the docker image.", default: true
  define_flag image, description: "Override the docker image."
  define_flag copy_resources : String,
    description: "The resource types to copy for copy-namespace.",
    short: r,
    long: resources,
    default: CopyNamespace::DEFAULT_RESOURCES
  define_flag force_copy : Bool,
    description: "Copy the namespace even the destination already exists."

  private def image
    generator.manifest.image || flags.image
  end

  def run
    kubectl_copy_namespace(flags.copy_namespace.to_s, namespace, flags.copy_resources, flags.force_copy) if flags.copy_namespace
    docker_build_and_push(generator.image) if !image && flags.push
    result = generator.result
    puts "Applying Kubernetes Manifests...".colorize(:cyan)
    result.items.map do |item|
      force = !item.is_a?(Kubernetes::Deployment)
      kubectl_new("apply", manifest: item, flags: {"--record" => !force, "--force" => force})
    end.all?(&.wait.success?) || panic("Failed kubectl apply.".colorize(:red))
    if deployment_generator.manifest.type == "Deployment"
      kubectl_run("rollout", ["status", "deployment/#{deployment_generator.manifest.name}"])
    end
  rescue e : Generator::ValidationError
    panic "Error: #{e.message}".colorize(:red)
  end
end
