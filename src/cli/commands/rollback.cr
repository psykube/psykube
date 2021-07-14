require "./concerns/*"

class Psykube::CLI::Commands::Rollback < Admiral::Command
  include Kubectl
  include KubectlAll

  define_help description: "Rollback a deployment."
  define_flag revision : Int32, description: "Revision to rollback to", default: 0

  def run
    puts "Rolling back #{flags.revision == 0 ? "to last revision" : "to revision `#{flags.revision}`"}.".colorize(:yellow)
    kubectl_run("rollout", ["undo", "#{actor.manifest.type.not_nil!.downcase}/#{actor.name}"], flags: {"--to-revision" => flags.revision.to_s})
    kubectl_run("rollout", ["status", "#{actor.manifest.type.not_nil!.downcase}/#{actor.name}"])
  end
end
