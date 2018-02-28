class Psykube::V1::Manifest::Ingress::Host::Path
  Manifest.mapping({
    port: String | Int32,
  })

  def initialize(@port : String | Int32)
  end
end
