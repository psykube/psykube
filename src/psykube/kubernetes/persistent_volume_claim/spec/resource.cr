require "../../../concerns/mapping"

class Psykube::Kubernetes::PersistentVolumeClaim::Spec::Resource
  Kubernetes.mapping(
    limits: Hash(String, String)?,
    requests: Hash(String, String)?
  )

  def initialize(size : String)
    @requests = {"storage" => size}
  end
end
