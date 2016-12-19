require "./kubernetes/*"
require "./manifest"

require "./generator/*"

class Psykube::Generator
  include Ingress
  include Service
  include ConfigMap
  include List

  getter manifest
  getter cluster_name

  def initialize(manifest_file : String, cluster_name : String)
    @manifest = Psykube::Manifest.from_yaml(File.read manifest_file)
    @cluster_name = cluster_name

    # Generate the kubernetes objects
    @config_map = generate_config_map
    # @secret = generate_secret
    # @deployment = generate_deployment
    @service = generate_service
    @ingress = generate_ingress

    # Generate the list after everything else is generated
    @list = generate_list
  end

  def to_yaml
    list.to_yaml
  end

  def cluster_manifest
    manifest.clusters[cluster_name]
  end

end
