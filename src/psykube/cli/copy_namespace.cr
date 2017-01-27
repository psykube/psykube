require "admiral"
require "./concerns/*"

class Psykube::Commands::CopyNamespace < Admiral::Command
  include Kubectl
  include KubectlClusterArg
  include PsykubeFileFlag
  include KubectlContextFlag

  define_help description: "Copy one namespace to another."

  define_flag resources : String,
    description: "The resource types to copy.",
    short: r,
    long: resources,
    default: "cm,secrets,deployments,services,pvc"
  define_flag force : Bool,
    description: "Copy the namspace even the destination already exists."

  define_argument from, description: "The namespace to copy resources from", required: true
  define_argument to, description: "The namespace to copy resources to", required: true

  private def namespace
    arguments.from
  end

  def run
    begin
      raise "forced" if flags.force
      Kubernetes::Namespace.from_json(kubectl_json(resource: "namespace", name: arguments.to))
      puts "Namespace exists, skipping copy...".colorize(:light_yellow)
    rescue
      puts "Copying Namespace: `#{arguments.from}` to `#{arguments.to}` (resources: #{flags.resources.split(",").join(", ")})...".colorize(:cyan)
      # Gather the existing resources
      json = kubectl_json(resource: flags.resources)
      list = Kubernetes::List.from_json json

      # Get or build the new namespace
      namespace = Kubernetes::Namespace.new(arguments.to)
      list.unshift namespace

      # Clean the list
      list.clean!
      kubectl_run(command: "apply", manifest: list)
    end
  end
end
