require "./concerns/*"

class Psykube::CLI::Commands::Push < Admiral::Command
  include Docker

  include PsykubeFileFlag
  include KubectlClusterArg
  define_help description: "Build and push the docker image."

  define_flag tags : Set(String),
    description: "Additional tags to push.",
    long: tag,
    short: t,
    default: Set(String).new

  def run
    if flags.tags.empty?
      docker_build_and_push(actor.buildable_contexts)
    else
      flags.tags.each do |tag|
        docker_build_and_push(actor.buildable_contexts, tag)
      end
    end
  end
end
