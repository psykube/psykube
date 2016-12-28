require "../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::PersistentVolumeClaim
  Kubernetes.mapping({
    claim_name: String,
    read_only:  Bool | Nil,
  })

  def initialize(@claim_name : String)
  end

  def initialize(@claim_name : String, @read_only : Bool | Nil)
  end
end
