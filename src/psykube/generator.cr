require "crustache"
require "./manifest"
require "./generator/*"

class Psykube::Generator
  alias TemplateData = Hash(String, Hash(String, String))

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

  def initialize(filename : String, cluster_name : String, tag : String = "latest", template_data : TemplateData = TemplateData.new)
    template = Crustache.parse File.read(filename)

    data = template_data.merge({
      "cluster" => {"name" => cluster_name},
      "env"     => ENV.keys.each_with_object({} of String => String) { |k, h| h[k] = ENV[k] },
    })

    @manifest = Manifest.from_yaml Crustache.render template, data
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
