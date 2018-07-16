require "./concerns/*"

class Psykube::CLI::Commands::DeleteNamespace < Admiral::Command
  include Kubectl
  include KubectlAll

  define_help description: "Delete the namespace for the specified configuration."

  define_flag confirm : Bool,
    description: "Don't ask for confirmation.",
    long: yes,
    short: y

  private def confirm?
    return true if flags.confirm
    print "Are you sure you want to delete the namespace #{namespace}? (y/n) "
    gets("\n").to_s.strip == "y"
  end

  def run
    kubectl_delete_namespace(namespace) if confirm?
  end
end
