require "yaml"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Container::VolumeMount
  YAML.mapping({
    name:       String,
    mount_path: {type: String, key: "mountPath"},
    sub_path:   {type: String, key: "subPath", nilable: true},
    read_only:  {type: Bool, nilable: true, key: "readOnly"},
  }, true)

  def initialize(@name : String, @mount_path : String)
  end
end
