require "yaml"

class Psykube::Manifest
  macro mapping(properties)
    ::YAML.mapping({{properties}}, true)
  end

  alias VolumeMap = Hash(String, Volume | String)
  mapping({
    name:            String,
    registry_host:   String?,
    registry_user:   String?,
    context:         String?,
    namespace:       String?,
    image:           String?,
    deploy_timeout:  {type: UInt32, nilable: true, getter: false},
    restart_policy:  String?,
    max_unavailable: {type: UInt32, nilable: true, getter: false},
    max_surge:       {type: UInt32, nilable: true, getter: false},
    command:         Array(String) | String | Nil,
    args:            Array(String)?,
    env:             {type: Hash(String, Env | String), nilable: true, getter: false},
    ingress:         Ingress?,
    service:         {type: Bool, default: true, getter: false},
    config_map:      {type: Hash(String, String), nilable: true, getter: false},
    secrets:         {type: Hash(String, String), nilable: true, getter: false},
    ports:           {type: Hash(String, UInt16), nilable: true, getter: false},
    clusters:        {type: Hash(String, Cluster), nilable: true, getter: false},
    healthcheck:     {type: Bool | Healthcheck, default: false},
    volumes:         {type: VolumeMap, nilable: true},
    autoscale:       {type: Autoscale, nilable: true},
    build_args:      {type: Hash(String, String), nilable: true, getter: false},
  })

  def deploy_timeout
    @deploy_timeout || 300_u32
  end

  def build_args
    @build_args || {} of String => String
  end

  def max_unavailable
    @max_unavailable || 0_u32
  end

  def max_surge
    @max_surge || 1_u32
  end

  def ports
    @ports || {} of String => UInt16
  end

  def config_map
    @config_map || {} of String => String
  end

  def secrets
    @secrets || {} of String => String
  end

  def env
    @env || {} of String => Env | String
  end

  def service?
    @ports && @service
  end

  def clusters
    @clusters || {} of String => Cluster
  end

  def env=(hash : Hash(String, String))
    @env = Hash(String, Env | String).new.tap do |h|
      hash.each do |k, v|
        h[k] = hash[k]
      end
    end
  end

  def env=(hash : Hash(String, Env))
    @env = Hash(String, Env | String).new.tap do |h|
      hash.each do |k, v|
        h[k] = hash[k]
      end
    end
  end
end

require "./manifest/*"
