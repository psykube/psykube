require "yaml"
require "../concerns/mapping"

class Psykube::Kubernetes::Shared::Metadata
  Kubernetes.mapping(
    name: String | Nil,
    generate_name: String | Nil,
    namespace: {type: String, nilable: true, clean: true},
    self_link: {type: String, nilable: true, setter: false, clean: true},
    uid: {type: String, nilable: true, setter: false, clean: true},
    resource_version: {type: String, nilable: true, setter: false, clean: true},
    generation: {type: Int32, nilable: true, setter: false, clean: true},
    creation_timestamp: {type: Time, nilable: true, setter: false, clean: true},
    deletion_timestamp: {type: Time, nilable: true, setter: false, clean: true},
    deletion_grace_period_seconds: {type: Int32, nilable: true, setter: false, clean: true},
    labels: Hash(String, String) | Nil,
    annotations: Hash(String, String) | Nil,
    owner_references: {type: Array(OwnerReference), nilable: true, setter: false, clean: true},
    finalizers: {type: Array(String), nilable: true, clean: true},
    cluster_name: {type: String, nilable: true, clean: true}
  )

  def initialize
  end

  def initialize(name : String)
    @name = name
  end

  def clean!
    annotations = self.annotations || {} of String => String
    annotations.delete("kubectl.kubernetes.io/last-applied-configuration") if annotations["kubectl.kubernetes.io/last-applied-configuration"]?
    super
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
