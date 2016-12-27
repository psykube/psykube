require "./concerns/resource"
require "./shared/metadata"

class Psykube::Kubernetes::PersistentVolumeClaim
  Resource.definition("v1", "PersistentVolumeClaim", {
    spec:   {type: Spec, default: Spec.new("10Gi")},
    status: {type: Status, nilable: true},
  })

  def initialize(name : String, size : String, access_modes : Array(String) = ["ReadWriteOnce"])
    initialize(name)
    @spec = Spec.new(size, access_modes)
  end
end

require "./persistent_volume_claim/*"
