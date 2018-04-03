require "./v2/*"

module Psykube::V2
  alias ClusterMap = Hash(String, Manifest::Shared::Cluster)
  alias ContainerMap = Hash(String, Manifest::Shared::Container)
  alias VolumeMountMap = Hash(String, String | Manifest::Shared::Container::VolumeMount)
  alias VolumeMap = Hash(String, String | Manifest::Volume::Claim | Manifest::Volume::Alias | Manifest::Volume::Spec)
end
