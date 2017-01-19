require "../../../concerns/mapping"

class Psykube::Kubernetes::Pod::Spec::Volume::AwsElasticBlockStore
  Kubernetes.mapping({
    volume_id: {type: String, key: "volumeID"},
    fs_type:   String,
    partition: UInt16?,
    read_only: Bool?,
  })
end
