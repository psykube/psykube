class Psykube::Manifest::Ingress::Host::Path
  Macros.mapping({
    port:         {type: String | Int32, optional: true},
    service_name: {type: String, optional: true},
  })

  def initialize(*, @port : String | Int32, @service_name : String? = nil)
  end
end
