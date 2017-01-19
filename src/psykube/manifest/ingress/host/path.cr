class Psykube::Manifest::Ingress::Host::Path
  Manifest.mapping({
    port: String | UInt16,
  })

  def initialize(@port : String | UInt16)
  end
end
