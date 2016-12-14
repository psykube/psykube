require "./psykube/manifest"

manifest = Psykube::Manifest.from_yaml(File.read(".psykube.yaml"))
kube_cm = manifest.kuberenetes_cluster_config_map("production")

puts kube_cm.to_yaml
