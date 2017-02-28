require "admiral"
require "./concerns/*"

class Psykube::Commands::Rollback < Admiral::Command
  include Kubectl
  include KubectlAll

  define_help description: "Rollback a deployment."

  define_flag revision : UInt64, description: "Revision to rollback to", default: 0_u64

  def run
    unless generator.manifest.type == "Deployment"
      panic "ERROR: #{flags.file} specified type `#{generator.manifest.type}`, rollouts can only be managed for `Deployment`.".colorize(:red)
    end
    puts "Rolling back #{flags.revision == 0 ? "to last deployment" : "to revision `#{flags.revision}`"}.".colorize(:yellow)
    kubectl_run("rollout", ["undo", "deployment/#{generator.manifest.name}"], flags: {"--to-revision" => flags.revision.to_s})
    kubectl_exec("rollout", ["status", "deployment/#{deployment_generator.manifest.name}"])
  end
end
