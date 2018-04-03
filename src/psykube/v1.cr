require "./v1/*"

module Psykube::V1
  alias VolumeMap = Hash(String, Manifest::Volume | String)
end
