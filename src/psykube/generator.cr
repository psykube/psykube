require "file_utils"

abstract class Psykube::Generator
  class ValidationError < Error; end

  alias TemplateData = StringMap

  include Concerns::MetadataHelper

  macro cast_manifest(type)
    def manifest : {{type}}
      @manifest.as({{type}})
    end
  end

  @role : String
  @actor : Actor
  getter manifest : Manifest::Any

  delegate name, cluster, tag, namespace, cluster_name, to: @actor
  delegate lookup_port, to: manifest

  def self.result(parent, *args, **params)
    new(parent).result(*args, **params)
  end

  def initialize(generator : Generator)
    @role = generator.@role
    @manifest = generator.@manifest
    @actor = generator.@actor
  end

  def initialize(@manifest : Manifest::Any, @actor : Actor)
    @role = @manifest.type.not_nil!
  end

  def to_yaml(*args, **props)
    result.to_yaml(*args, **props)
  end

  abstract def result(*args, **params)

  private def cluster_config_map
    manifest.config_map.merge cluster.config_map
  end

  private def cluster_secrets
    manifest.secrets.merge cluster.secrets
  end

  private def manifest_env
    manifest.env || {} of String => String | Manifest::Env
  end
end
