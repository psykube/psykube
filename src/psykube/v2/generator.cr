module Psykube::V2::Generator
  alias ConfigMap = V1::Generator::ConfigMap
  alias Secret = V1::Generator::Secret
end

require "./generator/concerns/*"
require "./generator/*"
