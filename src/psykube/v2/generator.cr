module Psykube::V2::Generator
  alias ConfigMap = V1::Generator::ConfigMap
  alias PersistentVolumeClaims = V1::Generator::PersistentVolumeClaims
  alias Secret = V1::Generator::Secret
end

require "./generator/concerns/*"
require "./generator/*"
