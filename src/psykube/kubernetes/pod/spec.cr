require "../../concerns/mapping"
require "../../shared/metadata"

class Psykube::Kubernetes::Pod::Spec
  Kubernetes.mapping({
    volumes:                          Array(Volume)?,
    containers:                       {type: Array(Container), default: [] of Container},
    restart_policy:                   String?,
    termination_grace_period_seconds: UInt32?,
    active_deadline_seconds:          UInt32?,
    dns_policy:                       String?,
    node_selector:                    Hash(String, String)?,
    service_account_name:             String?,
    service_account:                  String?,
    node_name:                        String?,
    host_network:                     String?,
    host_pid:                         String?,
    host_ipc:                         {type: String, nilable: true, key: "hostIPC"},
    security_context:                 Shared::SecurityContext?,
    image_pull_secrets:               Array(ImagePullSecret)?,
    hostname:                         String?,
    subdomain:                        String?,
  })
end

require "./spec/*"
require "../../shared/security_context"
