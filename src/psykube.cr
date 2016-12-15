require "./psykube/manifest"
require "./psykube/kubernetes/list"

manifest = Psykube::Manifest.from_yaml(File.read(".psykube.yaml"))
kube_cm = manifest.kuberenetes_cluster_config_map("production")
kube_svc = manifest.kuberenetes_cluster_service
kube_list = Psykube::Kubernetes::List.new([
  kube_cm,
  kube_svc
])

puts kube_list.to_yaml
