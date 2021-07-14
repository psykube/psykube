class Psykube::Manifest::Shared::PullSecretCredentials
  Macros.mapping({
    server:   {type: String, default: "https://index.docker.io/v1/"},
    username: {type: String},
    password: {type: String},
    email:    {type: String, default: ""},
  })
end
