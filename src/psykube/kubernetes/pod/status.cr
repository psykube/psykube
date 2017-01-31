require "../../concerns/mapping"

class Psykube::Kubernetes::Pod::Status
  Kubernetes.mapping({
    phase:              {type: String, setter: false, nilable: true},
    conditions:         {type: Array(Condition), setter: false, nilable: true},
    message:            {type: String, setter: false, nilable: true},
    reason:             {type: String, setter: false, nilable: true},
    host_ip:            {type: String, setter: false, nilable: true, key: "hostIP"},
    pod_ip:             {type: String, setter: false, nilable: true, key: "podIP"},
    start_time:         {type: Time, setter: false, nilable: true},
    container_statuses: {type: Array(ContainerStatus), setter: false, nilable: true},
  })
end

require "./status/*"
