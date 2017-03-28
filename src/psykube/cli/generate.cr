require "admiral"
require "./concerns/*"

class Psykube::Commands::Generate < Admiral::Command
  include PsykubeFileFlag
  include KubectlClusterArg
  include KubectlNamespaceFlag

  define_help description: "Generate the kubernetes manifests."
  define_flag image, description: "Override the docker image."
  define_flag pretty : Bool, description: "Prettyify the output", default: true

  def run
    if (io = @output_io).is_a?(IO::FileDescriptor)
      flags.pretty ? generator.to_pretty_json(io) : generator.to_json(io)
    end
  rescue e : Generator::ValidationError
    panic "Error: #{e.message}".colorize(:red)
  rescue e : Psykube::Manifest::ParseException
    panic e.message
  end
end
