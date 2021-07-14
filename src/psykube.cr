require "pyrite/versions/v1.17"
require "colorize"
require "digest"
require "yaml"
require "crustache"
require "openssl"

require "./psykube/concerns/*"
require "./psykube/*"

module Psykube
  {{ run "#{__DIR__}/parse_version.cr" }}

  LABELS = {
    "psykube" => "true",
  }

  alias StringMap = Hash(String, String)
  alias PortMap = Hash(String, Int32)
  alias ClusterMap = Hash(String, Manifest::Shared::Cluster)
  alias ContainerMap = Hash(String, Manifest::Shared::Container)
  alias VolumeMountMap = Hash(String, String | Manifest::Shared::Container::VolumeMount)
  alias VolumeMap = Hash(String, String | Manifest::Volume::Claim | Manifest::Volume::Alias | Manifest::Volume::Spec)
end
