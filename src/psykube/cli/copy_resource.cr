require "admiral"
require "./concerns/*"

class Psykube::Commands::CopyResource < Admiral::Command
  include Kubectl
  include PsykubeFileFlag
  include KubectlContextFlag

  define_help description: "Copy a resource."

  define_argument resource_type, required: true
  define_argument resource_name, required: true
  define_argument new_resource_name

  def new_resource_name
    if arguments.new_resource_name
      arguments.new_resource_name.to_s
    elsif !flags.dest_namespace.nil? && flags.dest_namespace != namespace
      arguments.resource_name
    else
      "#{arguments.resource_name}-copy"
    end
  end

  define_flag force : Bool, "Overwrite the resource if it exists."
  define_flag cluster, "The cluster configuration to use.", default: "default"
  define_flag namespace, description: "The namespace to copy the resource from", long: "source-namespace"
  define_flag dest_namespace, description: "The namespace to copy the resource to"

  def cluster_name
    flags.cluster
  end

  private def namespace
    generator.namespace
  end

  def run
    if dest_namespace = flags.dest_namespace
      dest_namespace = NamespaceCleaner.clean(dest_namespace)
    end
    json = kubectl_json(
      resource: arguments.resource_type,
      name: arguments.resource_name
    )
    resource = Kubernetes::List::ListableTypes.from_json(json)
    resource.clean!
    resource.name = new_resource_name
    kubectl_run(command: "apply", manifest: resource, flags: {"--force" => flags.force}, namespace: dest_namespace || namespace)
  end
end
