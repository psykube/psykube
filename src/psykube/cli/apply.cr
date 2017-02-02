require "admiral"
require "./concerns/*"

class Psykube::Commands::Apply < Admiral::Command
  include Docker
  include Kubectl
  include KubectlAll

  define_help description: "Apply the kubernetes manifests."

  define_flag copy_namespace, description: "Copy from the specified namespace if this one does not exist."
  define_flag push : Bool, description: "Build and push the docker image.", default: true
  define_flag image, description: "Override the docker image."
  define_flag copy_resources : String,
    description: "The resource types to copy for copy-namespace.",
    short: r,
    long: resources,
    default: CopyNamespace::DEFAULT_RESOURCES
  define_flag force_copy : Bool,
    description: "Copy the namspace even the destination already exists."

  private def image
    generator.manifest.image || flags.image
  end

  def run
    kubectl_copy_namespace(flags.copy_namespace.to_s, namespace, flags.copy_resources, flags.force_copy) if flags.copy_namespace
    docker_build_and_push(generator.image) if !image && flags.push
    result = generator.result
    result.items.map do |item|
      kubectl_new("apply", manifest: item, flags: {"--record" => true})
    end.all?(&.wait.success?) || panic("Failed kubectl apply.".colorize(:red))
    kubectl_run("rollout", ["status", "deployment/#{deployment_generator.manifest.name}"])
  rescue e : Generator::ValidationError
    panic "Error: #{e.message}".colorize(:red)
  end
end
