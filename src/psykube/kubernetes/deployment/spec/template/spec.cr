require "yaml"
require "../../../shared/metadata"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec
  YAML.mapping({
    volumes:                          Array(Volume) | Nil,
    containers:                       Array(Container),
    restart_policy:                   {type: String, nilable: true, key: "restartPolicy"},
    termination_grace_period_seconds: {type: UInt32, nilable: true, key: "terminationGracePeriodSeconds"},
    active_deadline_seconds:          {type: UInt32, nilable: true, key: "activeDeadlineSeconds"},
    dns_policy:                       {type: String, nilable: true, key: "dnsPolicy"},
    nodeSelector:                     Hash(String, String) | Nil,
    service_account_name:             {type: String, nilable: true, key: "serviceAccountName"},
    service_account:                  {type: String, nilable: true, key: "serviceAccount"},
    node_name:                        {type: String, nilable: true, key: "nodeName"},
    host_network:                     {type: String, nilable: true, key: "hostNetwork"},
    host_pid:                         {type: String, nilable: true, key: "hostPid"},
    host_ipc:                         {type: String, nilable: true, key: "hostIPC"},
    security_context:                 {type: Psykube::Kubernetes::Shared::SecurityContext, nilable: true, key: "securityContext"},
    image_pull_secrets:               {type: Array(ImagePullSecret), nilable: true, key: "imagePullSecrets"},
    hostname:                         String | Nil,
    subdomain:                        String | Nil,
  }, true)

  def initialize
    @containers = [] of Container
  end
end

require "./spec/*"
require "../../../shared/security_context"
