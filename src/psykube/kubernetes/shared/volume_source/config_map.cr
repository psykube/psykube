require "../../../concerns/mapping"
require "../../../shared/key_to_path"

class Psykube::Kubernetes::Shared::VolumeSource::ConfigMap
  alias KeyToPath = Shared::KeyToPath

  Kubernetes.mapping({
    name:         String,
    items:        Array(KeyToPath)?,
    default_mode: Int32?,
  })

  def initialize(name : String, item : String, default_mode : Int32? = nil)
    initialize(name, [item], default_mode)
  end

  def initialize(name : String, item : KeyToPath, default_mode : Int32? = nil)
    initialize(name, [item], default_mode)
  end

  def initialize(name : String, items : Array(String), default_mode : Int32? = nil)
    initialize(name, items.map { |str| KeyToPath.new(str) }, default_mode)
  end

  def initialize(@name : String, @items : Array(KeyToPath)? = nil, @default_mode : Int32? = nil)
  end
end
