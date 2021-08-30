class Psykube::Manifest::Ingress::Tls::Auto
  Macros.mapping({
    prefix: {type: String, optional: true},
    suffix: {type: String, optional: true},
  })
  def_clone
end
