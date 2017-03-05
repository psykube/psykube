require "../../generator"

module Psykube::Commands::PsykubeFileFlag
  private macro included
    # Flags
    define_flag file,
      description: "The location of the psykube manifest yml file.",
      short: f,
      default: "./.psykube.yml"
  end

  private def image_flag
    flags = @flags
    return unless flags.responds_to? :image
    flags.image
  end

  private def namespace_flag
    flags = @flags
    return unless flags.responds_to? :namespace
    flags.namespace
  end

  private def deployment_generator
    Generator::Deployment.new(
      filename: flags.file,
      image: image_flag,
      cluster_name: cluster_name,
      namespace: namespace_flag
    )
  end

  private def generator
    Generator::List.new(
      filename: flags.file,
      cluster_name: cluster_name,
      image: image_flag,
      namespace: namespace_flag
    )
  end
end
