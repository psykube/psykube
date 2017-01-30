require "yaml"

class Psykube::Manifest
  macro mapping(properties)
    ::YAML.mapping({{properties}}, true)
  end

  alias VolumeMap = Hash(String, Volume | String)
  mapping({
    name:          String,
    registry_host: String?,
    registry_user: String?,
    context:       String?,
    namespace:     String?,
    image:         String?,
    command:       Array(String) | String | Nil,
    args:          Array(String)?,
    env:           {type: Hash(String, Env | String), default: {} of String => Env | String},
    ingress:       Ingress?,
    service:       {type: Bool, default: true, getter: false},
    config_map:    {type: Hash(String, String), nilable: true},
    secrets:       {type: Hash(String, String), nilable: true},
    ports:         {type: Hash(String, UInt16), nilable: true},
    clusters:      {type: Hash(String, Cluster), nilable: true, getter: false},
    healthcheck:   {type: Bool | Healthcheck, default: true},
    volumes:       {type: VolumeMap, nilable: true},
    autoscale:     {type: Autoscale, nilable: true},
    build_args:    {type: Hash(String, String), nilable: true},
  })

  def port_map
    ports || {} of String => UInt16
  end

  def service
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
