require "./concerns/*"

class Psykube::CLI::Commands::Restart < Admiral::Command
  include Kubectl
  include KubectlAll
  include Docker

  define_help description: "Restart a kubernetes resource."

  def run
    if (actor.clusters.empty? || !actor.cluster.initialized?)
      if ["Deployment", "StatefulSet", "DaemonSet"].includes?(actor.manifest.type)
        kubectl_run("rollout", ["restart", "#{actor.manifest.type}/#{actor.manifest.name}".downcase])
      else
        raise Error.new "restart not supported for type: `#{actor.manifest.type}`"
      end
    else
      raise Error.new "cluster not defined: `#{actor.cluster_name}`"
    end
  end
end
