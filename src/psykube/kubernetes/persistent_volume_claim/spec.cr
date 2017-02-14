require "../../concerns/mapping"
require "../../shared/resource_requirements"
require "../../shared/selector"

class Psykube::Kubernetes::PersistentVolumeClaim::Spec
  Kubernetes.mapping({
    access_modes: Array(String)?,
    selector:     Shared::Selector?,
    resources:    Shared::ResourceRequirements?,
    volume_name:  {type: String, nilable: true, setter: false, clean: true},
  })

  def initialize(size : String, @access_modes : Array(String) = ["ReadWriteOnce"])
    @resources = Shared::ResourceRequirements.new.tap do |req|
      req.requests = {"storage" => size}
    end
  end
end

require "./spec/*"
