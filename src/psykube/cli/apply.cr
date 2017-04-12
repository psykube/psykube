require "admiral"
require "./concerns/*"

class Psykube::Commands::Apply < Admiral::Command
  private DOCKER = system "which docker" rescue false

  include Docker
  include Kubectl
  include KubectlAll

  define_help description: "Apply the kubernetes manifests."

  define_flag copy_namespace, description: CopyNamespace::DESCRIPTION
  define_flag push : Bool, description: "Build and push the docker image.", default: DOCKER
  define_flag image, description: "Override the docker image.", required: DOCKER
  define_flag copy_resources : String,
    description: "The resource types to copy for copy-namespace.",
    short: r,
    long: resources,
    default: CopyNamespace::DEFAULT_RESOURCES
  define_flag force_copy : Bool,
    description: "Copy the namespace even the destination already exists."
  define_flag force : Bool,
    description: "Force the recreation of the kubernetes resources."

  private def image
    generator.manifest.image || flags.image
  end

  def run
    kubectl_copy_namespace(flags.copy_namespace.to_s, namespace, flags.copy_resources, flags.force_copy) if flags.copy_namespace
    docker_build_and_push(generator.image) if !image && flags.push
    result = generator.result
    puts "Applying Kubernetes Manifests...".colorize(:cyan)
    result.items.map do |item|
      force = flags.force
      kubectl_new("apply", manifest: item, flags: {"--record" => !force, "--force" => force})
    end.all?(&.wait.success?) || panic("Failed kubectl apply.".colorize(:red))
    if deployment_generator.manifest.type == "Deployment"
      kubectl_run("rollout", ["status", "deployment/#{deployment_generator.name}"])
    end
  rescue e : Generator::ValidationError
    panic "Error: #{e.message}".colorize(:red)
  rescue e : Psykube::ParseException
    panic e.message
  end
end
