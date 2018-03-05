require "./v1/*"

module Psykube::V1
  alias ClusterMap = Hash(String, Manifest::Cluster)
  alias EnvMap = Hash(String, Manifest::Env | String)
  alias VolumeMap = Hash(String, Manifest::Volume | String)
end
