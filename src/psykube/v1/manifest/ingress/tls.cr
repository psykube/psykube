class Psykube::V1::Manifest::Ingress::Tls
  Macros.mapping({
    auto:        {type: Bool | Auto, optional: true},
    secret_name: {type: String, optional: true},
  })
end

require "./tls/*"
