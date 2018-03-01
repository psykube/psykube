require "./v2/*"

module Psykube::V2
  alias ClusterMap = Hash(String, Manifest::Shared::Cluster)
  alias ContainerMap = Hash(String, Manifest::Shared::Container)
end
