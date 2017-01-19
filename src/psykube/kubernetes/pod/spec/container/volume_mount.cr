require "../../../concerns/mapping"

class Psykube::Kubernetes::Pod::Spec::Container::VolumeMount
  Kubernetes.mapping({
    name:       String,
    mount_path: String,
    sub_path:   String?,
    read_only:  Bool?,
  })

  def initialize(@name : String, @mount_path : String)
  end
end
