require "./concerns/resource"
require "./shared/metadata"

class Psykube::Kubernetes::PersistentVolumeClaim
  Resource.definition("v1", "PersistentVolumeClaim", {
    spec:   {type: Spec, default: Spec.new("10Gi")},
    status: {type: Status, nilable: true, clean: true, setter: false},
  })

  def initialize(name : String, size : String, access_modes : Array(String) = ["ReadWriteOnce"])
    initialize(name)
    @spec = Spec.new(size, access_modes)
  end

  def clean!
    annotations = metadata.annotations || {} of String => String
    annotations.delete("pv.kubernetes.io/bind-completed") if annotations["pv.kubernetes.io/bind-completed"]?
    annotations.delete("pv.kubernetes.io/bound-by-controller") if annotations["pv.kubernetes.io/bound-by-controller"]?
    super
  end
end

require "./persistent_volume_claim/*"
