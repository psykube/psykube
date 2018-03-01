class Psykube::V1::Manifest::Ingress::Host::Path
  Macros.mapping({
    port: {type: String | Int32},
  })

  def initialize(@port : String | Int32)
  end
end
