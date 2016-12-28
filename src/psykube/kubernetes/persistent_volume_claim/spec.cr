require "../../concerns/mapping"

class Psykube::Kubernetes::PersistentVolumeClaim::Spec
  Kubernetes.mapping(
    access_modes: Array(String),
    selector: Shared::Selector | Nil,
    resources: Resource,
    volume_name: {type: String, nilable: true, setter: false}
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
