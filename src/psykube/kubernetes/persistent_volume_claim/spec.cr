require "yaml"

class Psykube::Kubernetes::PersistentVolumeClaim::Spec
  YAML.mapping(
    access_modes: {type: Array(String), key: "accessModes"},
    selector: {type: Shared::Selector, nilable: true},
    resources: {type: Resource},
    volume_name: {type: String, key: "volumeName", nilable: true, setter: false}
  )

  def initialize(size : String, @access_modes : Array(String))
    @resources = Resource.new(size)
  end

  def initialize(size)
    initialize(size, ["ReadWriteOnce"])
  end
end

require "./spec/*"
require "../../shared/selector"
