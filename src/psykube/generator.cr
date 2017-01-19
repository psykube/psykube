require "file_utils"
require "crustache"
require "./manifest"
require "./generator/*"

class Psykube::Generator
  alias TemplateData = Hash(String, String)

  @raw = false

  getter raw_manifest
  getter manifest
  getter cluster_name

  def self.yaml(filename : String, cluster_name : String, image : String = "", template_data : TemplateData = TemplateData.new)
    new(filename, cluster_name, image, template_data).to_yaml
  end

  def self.json(filename : String, cluster_name : String, image : String = "", template_data : TemplateData = TemplateData.new)
    new(filename, cluster_name, image, template_data).to_json
  end

  def self.result(generator : Generator)
    new(generator).result
  end

  def initialize(@manifest : Manifest, @cluster_name : String, image : String?)
    @raw_manifest = @manifest
    @raw = false
    @image = image unless image.to_s.empty?
  end

  def initialize(generator : Generator)
    @raw_manifest = generator.raw_manifest
    @manifest = generator.manifest
    @cluster_name = generator.cluster_name
    @image = generator.image
  end

  def initialize(filename : String, @cluster_name : String = "", image : String? = nil, template_data : TemplateData = TemplateData.new)
    contents = File.read(filename)
    @raw_manifest = Manifest.from_yaml contents
    template = Crustache.parse contents.gsub(/<<(.+)>>/, "{{\\1}}")

    data = {
      "metadata" => {
        "namespace"    => @raw_manifest.name,
        "cluster_name" => cluster_name,
      }.merge(template_data),
      "env" => ENV.keys.each_with_object({} of String => String) { |k, h| h[k] = ENV[k] },
    }

    @manifest = Manifest.from_yaml Crustache.render template, data
    @image = image unless image.to_s.empty?
  end

  def raw
    return nil if @raw
  end

  def image
    @image ||= [@manifest.registry_host, @manifest.registry_user, @manifest.name].compact.join('/')
  end

  def image(tag : String)
    [image, tag].join(":")
  end

  protected def result
    {} of String => String
  end

  def to_yaml
    result.to_yaml
  end

  def to_json
    result.to_json
  end

  private def cluster_manifest
    manifest.clusters[cluster_name]? || Manifest::Cluster.new
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
