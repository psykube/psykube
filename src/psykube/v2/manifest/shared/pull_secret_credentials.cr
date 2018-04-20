class Psykube::V2::Manifest::Shared::PullSecretCredentials
  Macros.mapping({
    server:   {type: String, optional: true},
    username: {type: String},
    password: {type: String},
    email:    {type: String},
  })
end
