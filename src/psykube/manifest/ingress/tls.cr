class Psykube::Manifest::Ingress::Tls
  Macros.mapping({
    auto:        {type: Bool | Auto, optional: true},
    secret_name: {type: String, optional: true},
  })

  def_clone
end

require "./tls/*"
