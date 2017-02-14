require "../../../concerns/mapping"

class Psykube::Kubernetes::Shared::VolumeSource::AwsElasticBlockStore
  Kubernetes.mapping({
    volume_id: {type: String, key: "volumeID"},
    fs_type:   String,
    partition: Int64?,
    read_only: Bool?,
  })
end
