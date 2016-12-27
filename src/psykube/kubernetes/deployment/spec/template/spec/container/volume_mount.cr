require "../../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Container::VolumeMount
  Kubernetes.mapping({
    name:       String,
    mount_path: {type: String, key: "mountPath"},
    sub_path:   {type: String, key: "subPath", nilable: true},
    read_only:  {type: Bool, nilable: true, key: "readOnly"},
  })

  def initialize(@name : String, @mount_path : String)
  end
end
