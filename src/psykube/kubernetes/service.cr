require "./concerns/resource"
require "./shared/network_status"

class Psykube::Kubernetes::Service
  include Resource
  definition("v1", "Service", {
    spec:   Spec?,
    status: {type: Shared::NetworkStatus, nilable: true, clean: true},
  })

  def initialize(name : String)
    previous_def(name)
    (metadata.labels ||= {} of String => String)["service"] = name
    spec = Spec.new
    spec.selector["app"] = name
    @spec = spec
  end

  def initialize(name : String, ports : Hash(String, UInt16))
    initialize(name)
    if spec = self.spec
      ports.each do |name, port|
        spec.ports.push(Spec::Port.new(name, port))
      end
    end
  end

  def initialize(name : String, ports : Nil)
    initialize(name)
  end
end

require "./service/*"
