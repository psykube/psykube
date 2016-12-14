require "yaml"
require "./shared/metadata"

class Psykube::Kubernetes::Service
  YAML.mapping(
    kind: String,
    apiVersion: String,
    metadata: {type: Psykube::Kubernetes::Shared::Metadata},
    spec: {type: Spec},
    status: {type: Status, nilable: true, setter: false}
  )

  def initialize
    @kind = "Service"
    @apiVersion = "v1"
    @metadata = Psykube::Kubernetes::Shared::Metadata.new
    @spec = Spec.new
  end

  def initialize(name : String, ports : Hash(String, UInt16))
    initialize
    metadata.name = name
    spec.selector["app"] = name
    ports.each do |name, port|
      spec.ports.push(Spec::Port.new(name, port))
    end
  end

  class Spec
    YAML.mapping(
      ports: {type: Array(Port), setter: false},
      selector: {type: Hash(String, String), default: {} of String => String},
      clusterIP: {type: String, nilable: true, setter: false},
      type: {type: String, nilable: true},
      externalIPs: {type: Array(String), nilable: true, setter: false},
      deprecatedPublicIPs: {type: Array(String), nilable: true, setter: false},
      sessionAffinity: {type: String, nilable: true},
      loadBalancerIP: {type: String, nilable: true, setter: false},
      loadBalancerSourceRanges: {type: Array(String), nilable: true},
      externalName: {type: String, nilable: true},
    )

    def initialize
      @ports = [] of Port
      @selector = {} of String => String
    end

    class Port
      YAML.mapping(
        name: {type: String},
        protocol: {type: String},
        port: {type: UInt16},
        targetPort: {type: UInt16, nilable: true},
        nodePort: {type: UInt16, nilable: true}
      )

      def initialize(name : String, port_number : UInt16)
        @name = name
        @port = port_number
        @protocol = "TCP"
      end
    end
  end

  class Status
    YAML.mapping(
      loadBalancer: {type: LoadBalancer, setter: false}
    )

    class LoadBalancer
      YAML.mapping(
        ingress: {type: Array(Ingress), setter: false}
      )

      class Ingress
        YAML.mapping(
          ip: {type: String, setter: false},
          hostname: {type: String, setter: false}
        )
      end
    end
  end
end
