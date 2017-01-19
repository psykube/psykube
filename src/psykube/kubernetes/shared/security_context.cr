require "../concerns/mapping"

class Psykube::Kubernetes::Shared::SecurityContext
  Kubernetes.mapping({
    capabilities:               Capabilities?,
    se_linux_options:           SeLinuxOptions?,
    run_as_user:                Int64?,
    run_as_not_root:            Bool?,
    read_only_root_file_system: Bool?,
  })
end

require "./security_context/*"
