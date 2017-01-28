require "file_utils"
require "crustache"
require "./manifest"
require "./generator/*"

class Psykube::Generator
  alias TemplateData = Hash(String, String)

  getter raw_manifest
  getter manifest
  getter cluster_name
  getter tag : String = "gitsha-#{`git rev-parse HEAD`.strip}"
  getter image : String

  def self.yaml(filename : String, cluster_name : String, image : String = "", template_data : TemplateData = TemplateData.new)
    new(filename, cluster_name, image, template_data).to_yaml
  end

  def self.json(filename : String, cluster_name : String, image : String = "", template_data : TemplateData = TemplateData.new)
    new(filename, cluster_name, image, template_data).to_json
  end

  def self.result(generator : Generator)
    new(generator).result
  end

  # def initialize(@manifest : Manifest, @cluster_name : String, image : String?)
  #   @image = image if image
  # end

  def initialize(generator : Generator)
    @manifest = generator.manifest
    @cluster_name = generator.cluster_name
    @image = generator.image
    @tag = generator.tag
  end

  def initialize(filename : String,
                 @cluster_name : String = "",
                 image : String? = nil,
                 tag : String? = nil,
                 template_data : TemplateData = TemplateData.new)
    @tag = tag if tag
    contents = File.read(filename)
    raw_manifest = Manifest.from_yaml contents
    template = Crustache.parse contents.gsub(/<<(.+)>>/, "{{\\1}}")

    data = {
      "metadata" => {
        "namespace"    => raw_manifest.name,
        "cluster_name" => cluster_name,
      }.merge(template_data),
      "env" => ENV.keys.each_with_object({} of String => String) { |k, h| h[k] = ENV[k] },
    }

    @manifest = Manifest.from_yaml Crustache.render template, data
    validate_image!
    @image = image || @manifest.image || default_image || raise("Image is not specified.")
  end

  def validate_image! : Nil
    if @manifest.image && (@manifest.registry_user || @manifest.registry_host)
      raise "Cannot specify both `image` and `registry` infromation in the same manifest!"
    end
  end

  private def default_image
    [@manifest.registry_host, @manifest.registry_user, @manifest.name].compact.join('/') + ":" + @tag
  end

  def to_yaml
    result.to_yaml
  end

  def to_json
    result.to_json
  end

  def context_name
    cluster_manifest.context_name || manifest.context_name
  end

  def namespace
    cluster_manifest.namespace || manifest.namespace
  end

  protected def result
    {} of String => String
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
