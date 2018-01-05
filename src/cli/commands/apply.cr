require "admiral"
require "./concerns/*"

class Psykube::CLI::Commands::Apply < Admiral::Command
  include Kubectl
  include KubectlAll

  {% if env("EXCLUDE_DOCKER") != "true" %}
  include Docker
  define_flag push : Bool, description: "Build and push the docker image.", default: true
  define_flag image, description: "Override the generated docker image."
  {% else %}
  define_flag image, description: "The docker image to apply.", required: true
  {% end %}
  define_flag tag, description: "The docker tag to apply.", short: t
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
  define_flag explicit_copy : Bool,
    description: %(Only copy resources that have the annotation "psykube.io/allow-copy" set to "true"),
    default: false

  define_help description: "Apply the kubernetes manifests."

  def run
    kubectl_copy_namespace(flags.copy_namespace.to_s, namespace, flags.copy_resources, flags.force_copy, flags.explicit_copy) if flags.copy_namespace
    {% if env("EXCLUDE_DOCKER") != "true" %}
    docker_build_and_push(generator.image) if !flags.tag && !flags.image && !generator.manifest.image && flags.push
    {% end %}
    result = generator.result
    puts "Applying Kubernetes Manifests...".colorize(:cyan)
    result.items.not_nil!.map do |item|
      force = flags.force
      if item.is_a?(Pyrite::Api::Core::V1::Service) && (service = Pyrite::Api::Core::V1::Service.from_json(kubectl_json(manifest: item, panic: false, error: false)) rescue nil)
        item.metadata.not_nil!.resource_version = service.metadata.not_nil!.resource_version
      end
      kubectl_new("apply", manifest: item, flags: {"--record" => !force, "--force" => force})
    end.all?(&.wait.success?) || panic("Failed kubectl apply.".colorize(:red))
    if deployment_generator.manifest.type == "Deployment"
      kubectl_run("rollout", ["status", "deployment/#{deployment_generator.name}"])
    end
    kubectl_run("annotate", ["namespace", namespace, "psykube.io/last-modified=#{Time.now.to_json}"], flags: {"--overwrite" => "true"})
  end
end
