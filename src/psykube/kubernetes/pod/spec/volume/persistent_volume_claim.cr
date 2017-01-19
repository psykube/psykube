require "../../../concerns/mapping"

class Psykube::Kubernetes::Pod::Spec::Volume::PersistentVolumeClaim
  Kubernetes.mapping({
    claim_name: String,
    read_only:  Bool?,
  })

  def initialize(@claim_name : String)
  end

  def initialize(@claim_name : String, @read_only : Bool?)
  end
end
