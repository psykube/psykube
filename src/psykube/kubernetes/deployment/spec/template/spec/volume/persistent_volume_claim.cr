require "yaml"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::PersistentVolumeClaim
  YAML.mapping({
    claim_name: {type: String, key: "claimName"},
    read_only:  {type: Bool, nilable: true, key: "readOnly"},
  }, true)

  def initialize(@claim_name : String)
  end

  def initialize(@claim_name : String, @read_only : Bool | Nil)
  end
end
