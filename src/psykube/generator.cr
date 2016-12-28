require "file_utils"
require "crustache"
require "./manifest"
require "./generator/*"

class Psykube::Generator
  alias TemplateData = Hash(String, String)

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

  def initialize(generator : Generator)
    @manifest = generator.manifest
    @cluster_name = generator.cluster_name
    @image = generator.image
  end

  def initialize(filename : String, cluster_name : String = "", image : String | Nil = nil, template_data : TemplateData = TemplateData.new)
    pre_template_manifest = Manifest.from_yaml File.read(filename)
    template = Crustache.parse File.read(filename)

    data = {
      "metadata" => {"name" => pre_template_manifest.name}.merge(template_data),
      "cluster"  => {"name" => cluster_name},
      "env"      => ENV.keys.each_with_object({} of String => String) { |k, h| h[k] = ENV[k] },
    }

    @manifest = Manifest.from_yaml Crustache.render template, data
    @cluster_name = cluster_name
    @image = image unless image.to_s.empty?
  end

  def image
    @image ||= [@manifest.registry_host, @manifest.registry_user, @manifest.name].compact.join('/')
  end

  def image(sha : Bool)
    if sha
      STDERR.puts "building docker image..."
      [image, `docker build -q .`.strip].join("@")
    else
      image
    end
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
    manifest.clusters[cluster_name]
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
