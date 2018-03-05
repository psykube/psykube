module Psykube::V2::Generator::Concerns::EnvHelper
  alias ValidationError = Psykube::Generator::ValidationError

  # Environment
  def generate_container_env(container)
    return if container.env.empty?
    container.env.map do |key, value|
      expand_env(key, value)
    end
  end

  private def expand_env(key : String, value : V1::Manifest::Env)
    value_from = Pyrite::Api::Core::V1::EnvVarSource.new.tap do |value_from|
      case
      when config_map = value.config_map
        value_from.config_map_key_ref = expand_env_config_map(config_map)
      when secret = value.secret
        value_from.secret_key_ref = expand_env_secret(secret)
      when field = value.field
        value_from.field_ref = expand_env_field(field)
      when resource_field = value.resource_field
        value_from.resource_field_ref = expand_env_resource_field(resource_field)
      end
    end
    Pyrite::Api::Core::V1::EnvVar.new(name: key, value_from: value_from)
  end

  private def expand_env(key : String, value : String)
    Pyrite::Api::Core::V1::EnvVar.new(name: key, value: value)
  end

  private def expand_env_config_map(key : String)
    raise ValidationError.new "ConfigMap `#{key}` not defined in cluster: `#{cluster_name}`." unless cluster_config_map.has_key? key
    Pyrite::Api::Core::V1::ConfigMapKeySelector.new(key: key, name: name)
  end

  private def expand_env_config_map(key_ref : V1::Manifest::Env::KeyRef)
    Pyrite::Api::Core::V1::ConfigMapKeySelector.new(key: key_ref.key, name: key_ref.name)
  end

  private def expand_env_secret(key : String)
    raise ValidationError.new "Secret `#{key}` not defined in cluster: `#{cluster_name}`." unless cluster_secrets.has_key? key
    Pyrite::Api::Core::V1::SecretKeySelector.new(key: key, name: name)
  end

  private def expand_env_secret(key_ref : V1::Manifest::Env::KeyRef)
    Pyrite::Api::Core::V1::SecretKeySelector.new(key: key_ref.key, name: key_ref.name)
  end

  private def expand_env_field(field : String)
    Pyrite::Api::Core::V1::ObjectFieldSelector.new(
      field_path: field
    )
  end

  private def expand_env_field(field_ref : V1::Manifest::Env::FieldRef)
    Pyrite::Api::Core::V1::ObjectFieldSelector.new(
      field_path: field_ref.path,
      api_version: field_ref.api_version
    )
  end

  private def expand_env_resource_field(resource_field : String)
    Pyrite::Api::Core::V1::ResourceFieldSelector.new(
      resource: resource_field
    )
  end

  private def expand_env_resource_field(field_ref : V1::Manifest::Env::ResourceFieldRef)
    Pyrite::Api::Core::V1::ResourceFieldSelector.new(
      resource: field_ref.resource,
      container_name: field_ref.container,
      divisor: field_ref.divisor
    )
  end
end
