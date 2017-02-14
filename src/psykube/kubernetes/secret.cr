require "./concerns/resource"
require "./shared/metadata"

class Psykube::Kubernetes::Secret
  include Resource
  definition("v1", "Secret", {
    data:       {type: Hash(String, String), default: {} of String => String},
    stringData: {type: Hash(String, String), default: {} of String => String, nilable: true},
    type:       String?,
  })

  def initialize(name : String, data : Hash(String, String))
    initialize(name)
    @data = data
  end
end
