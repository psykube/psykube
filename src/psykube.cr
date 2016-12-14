require "./psykube/manifest"

manifest = Psykube::Manifest.from_yaml(File.read(".psykube.yaml"))
kube_cm = manifest.kuberenetes_cluster_config_map("production")
kube_svc = manifest.kuberenetes_cluster_service

puts kube_cm.to_yaml
puts kube_svc.to_yaml
