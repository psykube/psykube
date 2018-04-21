class Psykube::V2::Manifest::Shared::PullSecretCredentials
  Macros.mapping({
    server:   {type: String, default: "https://index.docker.io/v1/"},
    username: {type: String},
    password: {type: String},
    email:    {type: String},
  })
end
