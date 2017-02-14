require "../../../concerns/mapping"

class Psykube::Kubernetes::Node::Status::NodeInfo
  Kubernetes.mapping({
    architecture:              String,
    boot_id:                   {type: String, key: "bootID"},
    container_runtime_version: String,
    kernel_version:            String,
    kube_proxy_version:        String,
    kubelet_version:           String,
    machine_id:                String,
    operating_system:          String,
    os_image:                  String,
    system_uuid:               {type: String, key: "systemUUID"},
  })
end
