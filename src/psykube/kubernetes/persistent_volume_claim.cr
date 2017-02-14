require "./concerns/resource"

class Psykube::Kubernetes::PersistentVolumeClaim
  include Resource
  definition("v1", "PersistentVolumeClaim", {
    spec:   Spec?,
    status: {type: Status, nilable: true, clean: true},
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
