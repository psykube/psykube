require "yaml"

class Psykube::Kubernetes::PersistentVolumeClaim::Spec
  YAML.mapping(
    access_modes: {type: Array(String), key: "accessModes"},
    selector: {type: Shared::Selector, nilable: true},
    resources: {type: Psykube::Kubernetes::PersistentVolumeClaim::Spec::Resource},
    volume_name: {type: String, key: "volumeName"}
  )

  def initialize
    @access_modes = [] of String
    @resources = Psykube::Kubernetes::PersistentVolumeClaim::Spec::Resource.new
    @volume_name = ""
  end
end

require "./spec/*"
require "../../shared/selector"
