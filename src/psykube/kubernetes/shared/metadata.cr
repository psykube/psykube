require "yaml"
require "../concerns/mapping"

class Psykube::Kubernetes::Shared::Metadata
  Kubernetes.mapping(
    name: String | Nil,
    generate_name: String | Nil,
    namespace: String | Nil,
    self_link: {type: String, nilable: true, setter: false},
    uid: {type: String, nilable: true, setter: false},
    resource_version: {type: String, nilable: true, setter: false},
    generation: {type: Int32, nilable: true, setter: false},
    creation_timestamp: {type: Time, nilable: true, setter: false},
    deletion_timestamp: {type: Time, nilable: true, setter: false},
    deletion_grace_period_seconds: {type: Int32, nilable: true, setter: false},
    labels: Hash(String, String) | Nil,
    annotations: Hash(String, String) | Nil,
    owner_references: {type: Array(OwnerReference), nilable: true, setter: false},
    finalizers: Array(String) | Nil,
    cluster_name: String | Nil
  )

  def initialize
  end

  def initialize(name : String)
    @name = name
  end

  class OwnerReference
    Kubernetes.mapping(
      apiVersion: {type: String},
      kind: {type: String},
      name: {type: String},
      uid: {type: String},
      controller: {type: Bool}
    )
  end
end
