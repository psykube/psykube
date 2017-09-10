require "admiral"
require "./concerns/*"

class Psykube::CLI::Commands::Generate < Admiral::Command
  include PsykubeFileFlag
  include KubectlClusterArg
  include KubectlNamespaceFlag

  define_help description: "Generate the kubernetes manifests."
  define_flag image, description: "Override the docker image."
  define_flag tag, description: "The docker tag to apply.", short: t
  define_flag pretty : Bool, description: "Prettyify the output", default: true

  def run
    if (io = @output_io).is_a?(IO::FileDescriptor)
      flags.pretty ? generator.to_pretty_json(io) : generator.to_json(io)
    end
  end
end
