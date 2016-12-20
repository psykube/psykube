require "yaml"

class Psykube::Manifest
  YAML.mapping(
    name: String,
    registry_host: String | Nil,
    registry_user: String,
    tags: {type: Array(String), default: [] of String},
    env: {type: Hash(String, Env | String), default: {} of String => Env | String},
    ingress: Ingress | Nil,
    service: {type: Bool, default: true},
    config_map: {type: Hash(String, String), default: {} of String => String},
    secrets: {type: Hash(String, String), default: {} of String => String},
    ports: {type: Hash(String, UInt16), default: {} of String => UInt16},
    clusters: {type: Hash(String, Cluster), default: {} of String => Cluster},
  )
end

require "./manifest/*"
require "./kubernetes/config_map"
require "./kubernetes/service"
require "./kubernetes/ingress"
require "./kubernetes/secret"
