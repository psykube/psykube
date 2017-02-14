require "../concerns/mapping"

class Psykube::Kubernetes::Shared::ResourceRequirements
  alias Map = Hash(String, String)

  Kubernetes.mapping(
    limits: Map?,
    requests: Map?
  )

  def initialize(@limits : Map? = nil, @requests : Map? = nil)
  end
end
