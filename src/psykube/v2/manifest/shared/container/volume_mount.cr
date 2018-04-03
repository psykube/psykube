class Psykube::V2::Manifest::Shared::Container::VolumeMount
  Macros.mapping({
    mount_path:        {type: String},
    mount_propagation: {type: String, optional: true},
    read_only:         {type: Bool, optional: true},
    sub_path:          {type: String, optional: true},
  })

  def to_container_volume_mount(name : String)
    Pyrite::Api::Core::V1::VolumeMount.new(
      name: name,
      mount_path: mount_path,
      mount_propagation: mount_propagation,
      read_only: read_only,
      sub_path: sub_path
    )
  end
end
