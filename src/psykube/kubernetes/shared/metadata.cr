require "yaml"

class Psykube::Kubernetes::Shared::Metadata
  YAML.mapping(
    name: {type: String, nilable: true},
    generateName: {type: String, nilable: true},
    namespace: {type: String, nilable: true},
    selfLink: {type: String, nilable: true, setter: false},
    uid: {type: String, nilable: true, setter: false},
    resourceVersion: {type: String, nilable: true, setter: false},
    generation: {type: Int32, nilable: true, setter: false},
    creationTimestamp: {type: Time, nilable: true, setter: false},
    deletionTimestamp: {type: Time, nilable: true, setter: false},
    deletionGracePeriodSeconds: {type: Int32, nilable: true, setter: false},
    labels: {type: Hash(String, String), nilable: true},
    annotations: {type: Hash(String, String), nilable: true},
    ownerReferences: {type: Array(OwnerReference), nilable: true, setter: false},
    finalizers: {type: Array(String), nilable: true},
    clusterName: {type: String, nilable: true}
  )

  def initialize
  end

  def initialize(name : String)
    @name = name
  end

  class OwnerReference
    YAML.mapping(
      apiVersion: {type: String},
      kind: {type: String},
      name: {type: String},
      uid: {type: String},
      controller: {type: Bool}
    )
  end
end
