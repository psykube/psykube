require "admiral"
require "./concerns/*"

class Psykube::Commands::CopyNamespace < Admiral::Command
  DEFAULT_RESOURCES = "cm,secrets,deployments,services,pvc"

  include Kubectl
  include PsykubeFileFlag
  include KubectlContextFlag

  define_help description: "Copy one namespace to another."

  define_flag cluster, "The cluster configuration to use.", default: "default"
  define_flag resources : String,
    description: "The resource types to copy.",
    short: r,
    long: resources,
    default: DEFAULT_RESOURCES
  define_flag force : Bool,
    description: "Copy the namspace even the destination already exists."

  define_argument from, description: "The namespace to copy resources from", required: true
  define_argument to, description: "The namespace to copy resources to", required: true

  def cluster_name
    flags.cluster
  end

  private def namespace
    arguments.from
  end

  def run
    kubectl_copy_namespace(arguments.from, arguments.to, flags.resources, flags.force)
  end
end
