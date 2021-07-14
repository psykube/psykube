require "pyrite/versions/v1.18"
require "colorize"
require "digest"
require "yaml"
require "crustache"
require "openssl"

require "./psykube/concerns/*"
require "./psykube/*"

module Psykube
  {{ run "#{__DIR__}/parse_version.cr" }}

  alias StringMap = Hash(String, String)
  alias StringableMap = Hash(String, String | Int32 | Bool | Float64 | Nil)
  alias PortMap = Hash(String, Int32)
  alias ClusterMap = Hash(String, Manifest::Shared::Cluster)
  alias ContainerMap = Hash(String, Manifest::Shared::Container)
  alias VolumeMountMap = Hash(String, String | Manifest::Shared::Container::VolumeMount)
  alias VolumeMap = Hash(String, String | Manifest::Volume::Claim | Manifest::Volume::Alias | Manifest::Volume::Spec)

  LABELS = StringableMap{"psykube" => true}
end
