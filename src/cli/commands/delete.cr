require "./concerns/*"

class Psykube::CLI::Commands::Delete < Admiral::Command
  include Kubectl
  include KubectlAll

  define_help description: "Delete the kubernetes manifests."

  define_flag confirm : Bool,
    description: "Don't ask for confirmation.",
    long: yes,
    short: y

  private def confirm?
    return true if flags.confirm
    print "Are you sure you want to delete the assets for #{actor.name}? (y/n) "
    gets("\n").to_s.strip == "y"
  end

  def run
    if confirm?
      puts "Deleting Kubernetes Manifests...".colorize(:yellow)
      success = actor.generate.as(Pyrite::Api::Core::V1::List).items.not_nil!.reject(&.kind.== "PersistentVolumeClaim").map do |item|
        kubectl_new("delete", manifest: item)
      end.all?(&.wait.success?) || panic("Failed kubectl delete.".colorize(:red))
    end
  end
end
