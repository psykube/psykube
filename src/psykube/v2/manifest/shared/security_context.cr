class Psykube::V2::Manifest::Shared::SecurityContext
  Macros.mapping({
    fs_group:            {type: Int32, optional: true},
    run_as_non_root:     {type: Bool, optional: true},
    run_as_user:         {type: Int32, optional: true},
    se_linux_options:    {type: Pyrite::Api::Core::V1::SELinuxOptions, optional: true},
    supplemental_groups: {type: Array(Int32), optional: true},
  })
end
