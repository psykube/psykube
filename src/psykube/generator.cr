require "file_utils"

abstract class Psykube::Generator
  class ValidationError < Error; end

  alias TemplateData = StringableMap

  include Concerns::MetadataHelper

  macro cast_manifest(type)
    def manifest : {{type}}
      @manifest.as({{type}})
    end
  end

  @role : String
  @actor : Actor
  getter manifest : Manifest

  delegate name, cluster, tag, namespace, cluster_name, to: @actor
  delegate ports, lookup_port, lookup_port!, to: manifest

  def self.result(parent, *args, **params)
    new(parent).result(*args, **params)
  end

  def initialize(generator : Generator)
    @role = generator.@role
    @manifest = generator.@manifest
    @actor = generator.@actor
  end

  def initialize(@manifest : Manifest, @actor : Actor)
    @role = @manifest.type.not_nil!
  end

  def to_yaml(*args, **props)
    result.to_yaml(*args, **props)
  end

  private def cluster_config_map
    manifest.config_map.merge cluster.config_map
  end

  private def secrets_disabled?
    manifest.secrets == false || cluster.secrets == false
  end

  private def combined_secrets
    return {} of String => String if secrets_disabled?
    manifest_secrets.merge(cluster_secrets)
  end

  private def combined_volumes
    case (c = cluster)
    when Psykube::Manifest::Shared::Cluster
      manifest.volumes.merge(c.volumes)
    else
      manifest.volumes
    end
  end

  private def manifest_secrets
    case (secrets = manifest.secrets)
    when Bool, Nil
      {} of String => String
    else
      stringify_hash_values(secrets)
    end
  end

  private def cluster_secrets
    case (secrets = cluster.secrets)
    when Bool, Nil
      {} of String => String
    else
      stringify_hash_values(secrets)
    end
  end

  private def manifest_env
    manifest.env || {} of String => String | Manifest::Env
  end
end

require "./generator/concerns/*"
require "./generator/*"
