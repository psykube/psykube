class Psykube::V2::Manifest::Shared::ServiceAccount
  Macros.mapping({
    automount_token:    {type: Bool, optional: true},
    image_pull_secrets: {type: Array(String), optional: true},
    secrets:            {type: Array(String | ObjectReference), optional: true},
  })
end
