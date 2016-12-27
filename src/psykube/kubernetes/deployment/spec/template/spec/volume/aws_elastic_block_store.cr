require "../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::AwsElasticBlockStore
  Kubernetes.mapping({
    volume_id: {type: String, key: "volumeID"},
    fs_type:   {type: String, key: "fsType"},
    partition: {type: UInt16, nilable: true},
    read_only: {type: Bool, nilable: true, key: "readOnly"},
  })
end
