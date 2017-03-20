require "../concerns/mapping"

class Psykube::Kubernetes::Shared::ResourceRequirements
  alias Map = Hash(String, String)

  Kubernetes.mapping(
    limits: Map?,
    requests: Map?
  )

  def initialize(@limits : Map? = nil, @requests : Map? = nil)
  end

  def limits=(hash)
    @limits = hash.each_with_object(Map.new) do |(k, v), map|
      map[k] = v unless v.nil?
    end
  end

  def requests=(hash)
    @requests = hash.each_with_object(Map.new) do |(k, v), map|
      map[k] = v unless v.nil?
    end
  end
end
