require "yaml"

class Psykube::Manifest
  alias VolumeMap = Hash(String, Psykube::Manifest::Volume | String)
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
  }, true)

  def full_env
    ports = self.ports || {} of String => UInt16
    port_env = { "PORT" => lookup_port("default").to_s }
    ports.each do |name, port|
      port_env["#{name.underscore.upcase}_PORT"] = port.to_s
    end
    env.merge(port_env)
  end

  def lookup_port(port : UInt16)
    port
  end

  def lookup_port(port_name : String)
    if port_name.to_u16?
      port_name.to_u16
    elsif port_name == "default" && !port_map.key?("default")
      port_map.values.first
    else
      port_map[port_name]
    end
  end

  private def port_map
    ports || {} of String => UInt16
  end
end

require "./manifest/*"
