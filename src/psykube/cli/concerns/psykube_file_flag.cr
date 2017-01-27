require "../../generator"

module Psykube::Commands::PsykubeFileFlag
  private macro included
    # Flags
    define_flag file,
      description: "The location of the psykube manfest yml file.",
      short: f,
      default: "./.psykube.yml"
  end

  private def generator
    arguments = @arguments
    Generator::List.new(
      filename: flags.file,
      image: arguments.responds_to?(:cluster) ? arguments.cluster : nil
    )
  end
end
