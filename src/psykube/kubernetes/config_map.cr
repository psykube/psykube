require "./concerns/resource"

class Psykube::Kubernetes::ConfigMap
  include Psykube::Kubernetes::Resource
  definition("v1", "ConfigMap", {
    data: {type: Hash(String, String), default: {} of String => String},
  })

  def initialize(name : String, data : Hash(String, String))
    initialize(name)
    @data = data
  end
end
