require "admiral"
require "./concerns/*"

class Psykube::Commands::Apply < Admiral::Command
  include Kubectl
  include KubectlAll

  {% if !`which docker || true`.empty? %}
  include Docker
  define_flag push : Bool, description: "Build and push the docker image.", default: true
  define_flag image, description: "Override the generated docker image."
  {% else %}
  define_flag image, description: "The docker image to apply.", required: true
  {% end %}
  define_flag copy_namespace, description: CopyNamespace::DESCRIPTION

  define_flag copy_resources : String,
    description: "The resource types to copy for copy-namespace.",
    short: r,
    long: resources,
    default: CopyNamespace::DEFAULT_RESOURCES
  define_flag force_copy : Bool,
    description: "Copy the namespace even the destination already exists."
  define_flag force : Bool,
    description: "Force the recreation of the kubernetes resources."

  define_help description: "Apply the kubernetes manifests."

  def run
    kubectl_copy_namespace(flags.copy_namespace.to_s, namespace, flags.copy_resources, flags.force_copy) if flags.copy_namespace
    {% if !`which docker || true`.empty? %}
    docker_build_and_push(generator.image) if !flags.image && !generator.manifest.image && flags.push
    {% end %}
    result = generator.result
    puts "Applying Kubernetes Manifests...".colorize(:cyan)
    result.items.map do |item|
      force = flags.force
      kubectl_new("apply", manifest: item, flags: {"--record" => !force, "--force" => force})
    end.all?(&.wait.success?) || panic("Failed kubectl apply.".colorize(:red))
    if deployment_generator.manifest.type == "Deployment"
      kubectl_run("rollout", ["status", "deployment/#{deployment_generator.name}"])
    end
  end
end
