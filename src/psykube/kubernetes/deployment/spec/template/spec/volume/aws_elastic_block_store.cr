require "../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::AwsElasticBlockStore
  Kubernetes.mapping({
    volume_id: {type: String, key: "volumeID"},
    fs_type:   String,
    partition: UInt16 | Nil,
    read_only: Bool | Nil,
  })
end
