require "admiral"
require "./concerns/*"

class Psykube::CLI::Commands::CopyResource < Admiral::Command
  include Kubectl
  include PsykubeFileFlag
  include KubectlContextFlag

  define_help description: "Copy a resource."

  define_flag force : Bool, "Overwrite the resource if it exists."
  define_flag cluster, "The cluster configuration to use.", default: "default"
  define_flag source_namespace, description: "The namespace to copy the resource from"
  define_flag namespace, description: "The namespace to copy the resource to", long: "dest-namespace"
  define_flag explicit : Bool,
    description: %(Only copy resources that have the annotation "psykube.io/allow-copy" set to "true"),
    default: false

  define_argument resource_type, required: true
  define_argument resource_name, required: true
  define_argument new_resource_name

  def run
    if source_namespace = flags.source_namespace
      source_namespace = NameCleaner.clean(source_namespace)
    end
    json = kubectl_json(
      resource: arguments.resource_type,
      name: arguments.resource_name,
      namespace: source_namespace || namespace
    )
    resource = Pyrite::Kubernetes::Resource.from_json(json)
    allow_copy = case resource.metadata.not_nil!.annotations.try(&.["psykube.io/allow-copy"]?)
                 when "true"
                   true
                 when "false"
                   false
                 else
                   !flags.explicit
                 end
    resource.metadata.not_nil!.name = new_resource_name
    kubectl_run(command: "apply", manifest: resource, flags: {"--force" => flags.force}) if allow_copy
  end

  private def new_resource_name
    if arguments.new_resource_name
      arguments.new_resource_name.to_s
    elsif !flags.source_namespace.nil? && flags.source_namespace != namespace
      arguments.resource_name
    else
      "#{arguments.resource_name}-copy"
    end
  end

  private def cluster_name
    flags.cluster
  end

  private def namespace
    actor.namespace
  end
end
