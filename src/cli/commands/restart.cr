require "./concerns/*"

class Psykube::CLI::Commands::Restart < Admiral::Command
  include Kubectl
  include KubectlAll
  include Docker

  define_help description: "Restart a kubernetes resource."
  define_flag wait : Bool, description: "Don't wait for the restart.", default: !Bool.from_yaml(ENV["PSYKUBE_NO_WAIT"]? || "false")

  def run
    if (actor.clusters.empty? || !actor.cluster.initialized?)
      if ["Deployment", "StatefulSet", "DaemonSet"].includes?(actor.manifest.type)
        kubectl_run("rollout", ["restart", "#{actor.manifest.type}/#{actor.manifest.name}".downcase])
        if ["Deployment", "StatefulSet", "DaemonSet"].includes?(actor.manifest.type) && flags.wait
          kubectl_run("rollout", ["status", "#{actor.manifest.type}/#{actor.name}".downcase])
        end
      else
        raise Error.new "restart not supported for type: `#{actor.manifest.type}`"
      end
    else
      raise Error.new "cluster not defined: `#{actor.cluster_name}`"
    end
  end
end
