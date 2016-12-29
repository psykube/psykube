require "yaml"

class Psykube::Manifest::Ingress::Host::Path
  YAML.mapping(
    port: String | UInt16
  )

  def initialize(@port : String | UInt16)
  end
end
