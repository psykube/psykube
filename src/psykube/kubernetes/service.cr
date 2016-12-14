require "yaml"
require "./shared/metadata"

class Psykube::Kuberenetes::Service
  YAML.mapping(
    kind: String,
    apiVersion: String,
    metadata: {type: Psykube::Kubernetes::Shared::Metadata},
    spec: {type:Spec}  #nillable?
  )

  class Spec
    YAML.mapping(
      ports: { type: Array(Port), nilable: true, setter: false},
      selector: { type: Hash(String,String), default: {} of String => String }, # --> ?
      clusterIP: { type: String, nilable: true}, #nillable?
      type: { type: String, nilable: false}, #nillable?
      externalIPs: { type: Array(String),nilable: true}, #nillable?
      deprecatedPublicIPs: { type: Array(String), nilable: true}, #nillable?
      sessionAffinity: { type: String, nilable: true}, #nillable?
      loadBalancerIP: { type: String, nilable: true}, #nillable
      loadBalancerSourceRanges: { type: Array(String), nilable: true},  #nillable?
      externalName: { type: String, nilable: true}, #nillable?
    )

    class Port
      YAML.mapping(
        name: String,
        protocol: String,
        port: { type:Uint16},
        targetPort: String,
        nodePort: { type: Uint16}
      )
    end
  end

  class Status
    YAML.mapping(
      loadBalancer: { type:LoadBalancer, nillable: true} #nillable?
    )

    class LoadBalancer
      YAML.mapping(
        ingress: { type: Array(Ingress), nilable: true} # nillable?
      )

      class Ingress
        YAML.mapping(
          ip: String,
          hostname: String
        )
      end
    end
  end
end
