require "./v2/*"

module Psykube::V2
  alias ClusterMap = Hash(String, Manifest::Shared::Cluster)
  alias ContainerMap = Hash(String, Manifest::Shared::Container)
  alias EnvMap = Hash(String, V1::Manifest::Env | String)
  alias VolumeMap = Hash(String, V1::Manifest::Volume | String)
end
