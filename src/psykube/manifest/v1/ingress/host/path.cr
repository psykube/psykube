class Psykube::Manifest::V1::Ingress::Host::Path
  Manifest.mapping({
    port: String | Int32,
  })

  def initialize(@port : String | Int32)
  end
end
