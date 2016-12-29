require "../../concerns/mapping"

class Psykube::Kubernetes::Pod::Spec::ImagePullSecret
  Kubernetes.mapping({
    name: String,
  })

  def initialize(@name : String)
  end
end
