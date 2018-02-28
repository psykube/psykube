module Psykube::CLI::Commands::PsykubeFileFlag
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

  private def tag_flag
    flags = @flags
    return unless flags.responds_to? :tag
    flags.tag
  end

  private def namespace_flag
    flags = @flags
    return unless flags.responds_to? :namespace
    flags.namespace
  end

  private def actor
    Actor.new(self)
  end

  private def deployment
    deployment = actor.generate.items.not_nil!.find(&.kind.== "Deployment")
    deployment.as(Pyrite::Api::Extensions::V1beta1::Deployment) if deployment
  end
end
