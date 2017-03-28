require "admiral"
require "./concerns/*"

class Psykube::Commands::History < Admiral::Command
  include Kubectl
  include KubectlAll

  define_help description: "Get the rollout history of a deployment."

  def run
    unless generator.manifest.type == "Deployment"
      panic "ERROR: #{flags.file} specified type `#{generator.manifest.type}`, rollouts can only be managed for `Deployment`.".colorize(:red)
    end
    kubectl_run("rollout", ["history", "deployment/#{generator.name}"])
  rescue e : Psykube::Manifest::ParseException
    panic e.message
  end
end
