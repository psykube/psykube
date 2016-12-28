require "./concerns/resource"
require "./shared/status"

class Psykube::Kubernetes::Service
  Resource.definition("v1", "Service", {
    spec:   Spec,
    status: {type: Shared::Status, nilable: true, clean: true, setter: false},
  })

  def initialize(name : String)
    initialize
    metadata.name = name
    spec.selector["app"] = name
  end

  def initialize(name : String, ports : Hash(String, UInt16))
    initialize(name)
    ports.each do |name, port|
      spec.ports.push(Spec::Port.new(name, port))
    end
  end

  def initialize(name : String, ports : Nil)
    initialize(name)
  end
end

require "./service/*"
