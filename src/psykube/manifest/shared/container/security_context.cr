class Psykube::Manifest::Shared::Container::SecurityContext
  Macros.mapping({
    allow_privilege_escalation: {type: Bool, optional: true},
    capabilities:               {type: Pyrite::Api::Core::V1::Capabilities, optional: true},
    privileged:                 {type: Bool, optional: true},
    read_only_root_filesystem:  {type: Bool, optional: true},
    run_as_non_root:            {type: Bool, optional: true},
    run_as_user:                {type: Int32, optional: true},
    se_linux_options:           {type: Pyrite::Api::Core::V1::SELinuxOptions, optional: true},
  })
end
