require "../../../../concerns/mapping"

class Psykube::Kubernetes::Pod::Spec::Container::Env::ValueFrom::FieldRef
  Kubernetes.mapping({
    api_version: String | Nil,
    field_path:  String,
  })

  def initialize(@field_path : String, @api_version : String? = nil)
  end
end
