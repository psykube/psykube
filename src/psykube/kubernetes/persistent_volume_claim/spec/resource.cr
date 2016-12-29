require "../../../concerns/mapping"

class Psykube::Kubernetes::PersistentVolumeClaim::Spec::Resource
  Kubernetes.mapping(
    limits: Hash(String, String) | Nil,
    requests: Hash(String, String) | Nil
  )

  def initialize(size : String)
    @requests = {"storage" => size}
  end
end
