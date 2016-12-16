require "./psykube/manifest"

manifest = Psykube::Manifest.from_yaml(File.read(".psykube.yaml"))
kube_cm = manifest.kubernetes_cluster_config_map("production")
kube_svc = manifest.kubernetes_cluster_service
kube_ing = manifest.kubernetes_cluster_ingress

puts kube_cm.to_yaml
puts kube_svc.to_yaml
puts kube_ing.to_yaml
