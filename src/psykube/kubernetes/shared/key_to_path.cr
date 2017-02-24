require "../concerns/mapping"

class Psykube::Kubernetes::Shared::KeyToPath
  Kubernetes.mapping({
    key:  String,
    path: String?,
    mode: Int32?,
  })

  def initialize(@key : String, path : String? = nil, @mode : Int32? = nil)
    @path = path || key
  end
end
