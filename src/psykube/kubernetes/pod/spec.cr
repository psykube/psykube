require "../../concerns/mapping"
require "../../shared/metadata"

class Psykube::Kubernetes::Pod::Spec
  Kubernetes.mapping({
    volumes:                          Array(Volume) | Nil,
    containers:                       {type: Array(Container), default: [] of Container},
    restart_policy:                   String | Nil,
    termination_grace_period_seconds: UInt32 | Nil,
    active_deadline_seconds:          UInt32 | Nil,
    dns_policy:                       String | Nil,
    node_selector:                    Hash(String, String) | Nil,
    service_account_name:             String | Nil,
    service_account:                  String | Nil,
    node_name:                        String | Nil,
    host_network:                     String | Nil,
    host_pid:                         String | Nil,
    host_ipc:                         {type: String, nilable: true, key: "hostIPC"},
    security_context:                 Shared::SecurityContext | Nil,
    image_pull_secrets:               Array(ImagePullSecret) | Nil,
    hostname:                         String | Nil,
    subdomain:                        String | Nil,
  })
end

require "./spec/*"
require "../../shared/security_context"
