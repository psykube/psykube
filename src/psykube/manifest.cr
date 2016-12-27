require "yaml"

class Psykube::Manifest
  alias VolumeMap = Hash(String, Volume | String)
  YAML.mapping({
    name:          String,
    registry_host: String | Nil,
    registry_user: String,
    tags:          {type: Array(String), default: [] of String},
    env:           {type: Hash(String, Env | String), default: {} of String => Env | String},
    ingress:       Ingress | Nil,
    service:       {type: Bool, default: true},
    config_map:    {type: Hash(String, String), nilable: true},
    secrets:       {type: Hash(String, String), nilable: true},
    ports:         {type: Hash(String, UInt16), nilable: true},
    clusters:      {type: Hash(String, Cluster), default: {} of String => Cluster},
    healthcheck:   {type: Bool | Healthcheck, default: true},
    volumes:       {type: VolumeMap, nilable: true},
    autoscale:     {type: Autoscale, nilable: true},
  }, true)

  def port_map
    ports || {} of String => UInt16
  end
end

require "./manifest/*"
