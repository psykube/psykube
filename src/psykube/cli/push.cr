require "admiral"
require "./concerns/*"

class Psykube::Commands::Push < Admiral::Command
  include Docker

  include PsykubeFileFlag
  define_help description: "Build and push the docker image."

  define_flag tags : Set(String),
    description: "Additional tags to push.",
    long: tag,
    short: t,
    default: Set(String).new

  def run
    return docker_build_and_push(generator.image) if flags.tags.empty?
    flags.tags.each { |tag| docker_build_and_push tag }
  end
end
