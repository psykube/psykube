require "crustache"
require "./manifest"
require "./generator/*"

class Psykube::Generator
  alias TemplateData = Hash(String, Hash(String, String))

  getter manifest
  getter cluster_name
  getter tag

  def self.yaml(filename : String, cluster_name : String, tag : String = "latest", template_data : TemplateData = TemplateData.new)
    new(filename, cluster_name, tag, template_data)
  end

  def self.result(generator : Generator)
    new(generator).result
  end

  def initialize(generator : Generator)
    @manifest = generator.manifest
    @cluster_name = generator.cluster_name
    @tag = generator.tag
  end

  def initialize(filename : String, cluster_name : String, tag : String = "latest", template_data : TemplateData = TemplateData.new)
    template = Crustache.parse File.read(filename)

    data = template_data.merge({
      "cluster" => {"name" => cluster_name},
      "env"     => ENV.keys.each_with_object({} of String => String) { |k, h| h[k] = ENV[k] },
    })

    @manifest = Manifest.from_yaml Crustache.render template, data
    @cluster_name = cluster_name
    @tag = tag
  end

  protected def result
    {} of String => String
  end

  def to_yaml
    result.to_yaml
  end

  private def cluster_manifest
    manifest.clusters[cluster_name]
  end

  private def container_image
    parts = [
      manifest.registry_host,
      manifest.registry_user,
      manifest.name,
    ]
    image = parts.compact.join("/")
    [image, tag].join(":")
  end

  private def lookup_port(port : UInt16)
    port
  end

  private def lookup_port(port_name : String)
    if port_name.to_u16?
      port_name.to_u16
    elsif port_name == "default" && !manifest.port_map.key?("default")
      manifest.port_map.values.first
    else
      manifest.port_map[port_name]
    end
  end
end
