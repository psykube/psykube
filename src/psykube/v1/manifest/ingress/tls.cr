class Psykube::V1::Manifest::Ingress::Tls
  Macros.mapping({
    auto:        {type: Bool | Auto, nilable: true},
    secret_name: {type: String, nilable: true},
  })
end

require "./tls/*"
