require "./psykube/manifest"

puts Psykube::Manifest.from_yaml(File.read(".psykube.yaml")).to_yaml
