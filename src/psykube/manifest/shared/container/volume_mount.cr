class Psykube::Manifest::Shared::Container::VolumeMount
  Macros.mapping({
    mount_path:        {type: String},
    mount_propagation: {type: String, optional: true},
    read_only:         {type: Bool, optional: true},
    sub_path:          {type: String, optional: true},
  })
end
