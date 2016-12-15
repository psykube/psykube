require "yaml"
require "./shared/*"

class Psykube::Kubernetes::Service
  YAML.mapping(
    kind: String,
    apiVersion: String,
    metadata: {type: Psykube::Kubernetes::Shared::Metadata},
    spec: {type: Psykube::Kubernetes::Service::Spec},
    status: {type: Psykube::Kubernetes::Shared::Status, nilable: true, setter: false}
  )

  def initialize
    @kind = "Service"
    @apiVersion = "v1"
    @metadata = Psykube::Kubernetes::Shared::Metadata.new
    @spec = Psykube::Kubernetes::Service::Spec.new
  end

  def initialize(name : String, ports : Hash(String, UInt16))
    initialize
    metadata.name = name
    spec.selector["app"] = name
    ports.each do |name, port|
      spec.ports.push(Psykube::Kubernetes::Service::Spec::Port.new(name, port))
    end
  end
end

require "./service/*"
