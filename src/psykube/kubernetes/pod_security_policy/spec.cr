require "../../concerns/mapping"
require "../../shared/security_context/se_linux_options"

class Psykube::Kubernetes::PodSecurityPolicy::Spec
  Kubernetes.mapping({
    privileged:                 Bool?,
    default_add_capabilities:   Array(String)?,
    required_drop_capabilities: Array(String)?,
    allowed_capabilities:       Array(String)?,
    volumes:                    Array(String)?,
    host_network:               Bool?,
    host_ports:                 Array(PortRange)?,
    host_pid:                   {type: Bool, nilable: true, key: "hostPID"},
    host_ipc:                   {type: Bool, nilable: true, key: "hostIPC"},
    se_linux_options:           Shared::SecurityContext::SeLinuxOptions,
    run_as_user:                StrategyOption,
    supplemental_groups:        StrategyOption,
    fs_group:                   StrategyOption,
    read_only_root_file_system: Bool?,
  })
end

require "./spec/*"
