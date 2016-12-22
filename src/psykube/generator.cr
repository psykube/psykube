require "./kubernetes/*"
require "./manifest"

require "./generator/*"

class Psykube::Generator
  include Ingress
  include Service
  include ConfigMap
  include Secret
  include List
  include Deployment
  include PersistentVolumeClaims

  getter manifest
  getter cluster_name
  getter tag

  def initialize(filename : String, cluster_name : String, tag : String = "latest")
    @manifest = Psykube::Manifest.from_yaml(File.read(filename))
    @cluster_name = cluster_name
    @tag = tag

    # Generate the kubernetes objects
    @config_map = generate_config_map
    @deployment = generate_deployment
    @secret = generate_secret
    @service = generate_service
    @ingress = generate_ingress
    @persistent_volume_claims = generate_persistent_volume_claims

    # Generate the list after everything else is generated
    @list = generate_list
  end

  def to_yaml
    list.to_yaml
  end

  def cluster_manifest
    clusters[cluster_name]
  end

  def container_image
    parts = [
      registry_host,
      registry_user,
      name,
    ]
    image = parts.compact.join("/")
    [image, tag].join(":")
  end

  forward_missing_to @manifest
end
