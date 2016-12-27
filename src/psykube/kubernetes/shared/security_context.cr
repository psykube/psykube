require "../concerns/mapping"

class Psykube::Kubernetes::Shared::SecurityContext
  Kubernetes.mapping({
    capabilities:               Capabilities | Nil,
    se_linux_options:           {type: SeLinuxOptions, nilable: true, key: "seLinuxOptions"},
    run_as_user:                {type: Int64, nilable: true, key: "runAsUser"},
    run_as_not_root:            {type: Bool, nilable: true, key: "runAsNonRoot"},
    read_only_root_file_system: {type: Bool, nilable: true, key: "readOnlyRootFilesystem"},
  })
end

require "./security_context/*"
