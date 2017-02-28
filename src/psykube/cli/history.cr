require "admiral"
require "./concerns/*"

class Psykube::Commands::History < Admiral::Command
  include Kubectl
  include KubectlAll

  define_help description: "Apply the kubernetes manifests."

  def run
    kubectl_exec("rollout", ["history", "deployment/#{generator.manifest.name}"])
  end
end
