require "./concerns/*"

class Psykube::CLI::Commands::Push < Admiral::Command
  include Docker

  include PsykubeFileFlag
  define_help description: "Build and push the docker image."

  define_flag tags : Set(String),
    description: "Additional tags to push.",
    long: tag,
    short: t,
    default: Set(String).new

  getter cluster_name = ""

  def run
    return docker_build_and_push(actor.all_build_contexts) if flags.tags.empty?
    flags.tags.each { |tag| docker_build_and_push(actor.build_contexts, tag) }
  end
end
