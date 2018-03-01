module Psykube::V2::Generator
  alias Autoscale : V1::Generator::Autoscale
  alias ConfigMap : V1::Generator::ConfigMap
  alias Ingress : V1::Generator::Ingress
  alias PersistentVolumeClaims : V1::Generator::PersistentVolumeClaims
  alias Secret : V1::Generator::Secret
  alias Service : V1::Generator::Service
end

require "./generator/concerns/*"
require "./generator/*"
