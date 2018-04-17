require "./concerns/*"

class Psykube::CLI::Commands::CreateNamespace < Admiral::Command
  include Kubectl
  include KubectlAll

  define_help description: "Create the namespace for the specified configuration"

  def run
    kubectl_create_namespace(namespace)
  end
end
