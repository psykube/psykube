class Psykube::V1::Manifest::Ingress::Tls
  Manifest.mapping({
    auto:        Bool | Auto | Nil,
    secret_name: String?,
  })
end

require "./tls/*"
