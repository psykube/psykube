require "yaml"
require "./shared/*"

class Psykube::Kubernetes::Service
  YAML.mapping(
    kind: String,
    apiVersion: String,
    metadata: {type: Shared::Metadata},
    spec: {type: Psykube::Kubernetes::Service::Spec},
    status: {type: Shared::Status, nilable: true, setter: false}
  )

  def initialize
    @kind = "Service"
    @apiVersion = "v1"
    @metadata = Shared::Metadata.new
    @spec = Psykube::Kubernetes::Service::Spec.new
  end

  def initialize(name : String)
    initialize
    metadata.name = name
    spec.selector["app"] = name
  end

  def initialize(name : String, ports : Hash(String, UInt16))
    initialize(name)
    ports.each do |name, port|
      spec.ports.push(Psykube::Kubernetes::Service::Spec::Port.new(name, port))
    end
  end

  def initialize(name : String, ports : Nil)
    initialize(name)
  end
end

require "./service/*"
