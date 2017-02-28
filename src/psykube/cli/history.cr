require "admiral"
require "./concerns/*"

class Psykube::Commands::History < Admiral::Command
  include Kubectl
  include KubectlAll

  define_help description: "Get the rollout history of a deployment."

  def run
    kubectl_exec("rollout", ["history", "deployment/#{generator.manifest.name}"])
  end
end
