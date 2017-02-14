require "./concerns/resource"
require "./shared/network_status"

class Psykube::Kubernetes::Service
  include Resource
  definition("v1", "Service", {
    spec:   Spec?,
    status: {type: Shared::NetworkStatus, nilable: true, clean: true},
  })

  def initialize(name : String)
    initialize
    metadata.name = name
    spec = Spec.new
    spec.selector["app"] = name
    @spec = spec
  end

  def initialize(name : String, ports : Hash(String, UInt16))
    initialize(name)
    spec = Spec.new
    ports.each do |name, port|
      spec.ports.push(Spec::Port.new(name, port))
    end
    @spec = spec
  end

  def initialize(name : String, ports : Nil)
    initialize(name)
  end
end

require "./service/*"
