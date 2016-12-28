require "../concerns/mapping"

class Psykube::Kubernetes::Shared::SecurityContext
  Kubernetes.mapping({
    capabilities:               Capabilities | Nil,
    se_linux_options:           SeLinuxOptions | Nil,
    run_as_user:                Int64 | Nil,
    run_as_not_root:            Bool | Nil,
    read_only_root_file_system: Bool | Nil,
  })
end

require "./security_context/*"
