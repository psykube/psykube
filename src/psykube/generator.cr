require "file_utils"
require "crustache"
require "./manifest"
require "./generator/*"

class Psykube::Generator
  alias TemplateData = Hash(String, String)

  @manifest : Manifest?
  @template_yaml : Crustache::Syntax::Template?

  getter yaml : String = ""
  getter cluster_name : String = "default"
  getter context : String?
  getter namespace : String = "default"
  getter tag : String = "gitsha-#{`git rev-parse HEAD`.strip}"
  getter image : String

  def self.yaml(filename : String, cluster_name : String, image : String = "", template_data : TemplateData = TemplateData.new)
    new(filename, cluster_name, image, template_data).to_yaml
  end

  def self.json(filename : String, cluster_name : String, image : String = "", template_data : TemplateData = TemplateData.new)
    new(filename, cluster_name, image, template_data).to_json
  end

  def self.result(*args, **params)
    new(*args, **params).result
  end

  def initialize(generator : Generator)
    @manifest = generator.manifest
    @cluster_name = generator.cluster_name
    @context = generator.context
    @namespace = generator.namespace
    @image = generator.image
    @tag = generator.tag
  end

  def initialize(filename : String, cluster_name : String? = nil, context : String? = nil, namespace : String? = nil, image : String? = nil, tag : String? = nil)
    @yaml = File.read(filename)
    @tag = tag if tag
    @cluster_name = cluster_name if cluster_name
    @context = context || raw_cluster_manifest.context || raw_manifest.context
    namespace ||= raw_cluster_manifest.namespace || raw_manifest.namespace
    @namespace = namespace.sub(/^[^a-z0-9]+/, "").sub(/[^a-z0-9]+$/, "").gsub(/[^-a-z0-9]/, "-") if namespace
    validate_image!
    @image = image || manifest.image || default_image || raise("Image is not specified.")
  end

  def raw_manifest
    @raw_manifest ||= Manifest.from_yaml(Crustache.render template_yaml, {
      "env" => env_hash,
    })
  end

  def manifest
    @manifest ||= Manifest.from_yaml(Crustache.render template_yaml, {
      "metadata" => {"namespace" => namespace, "cluster_name" => cluster_name},
      "env"      => env_hash,
    })
  end

  private def env_hash
    ENV.keys.each_with_object({} of String => String) { |k, h| h[k] = ENV[k] }.reject { |k, v| v.empty? }
  end

  def validate_image! : Nil
    if manifest.image && (manifest.registry_user || manifest.registry_host)
      raise "Cannot specify both `image` and `registry` infromation in the same manifest!"
    end
  end

  def image(tag)
    image.sub(/:.+$/, ":" + tag)
  end

  private def default_image
    [manifest.registry_host, manifest.registry_user, manifest.name].compact.join('/') + ":" + @tag
  end

  def to_yaml
    result.to_yaml
  end

  def to_json
    result.to_json
  end

  protected def result
    {} of String => String
  end

  private def template_yaml
    @template_yaml ||= Crustache.parse yaml.gsub(/<<(.+)>>/, "{{\\1}}")
  end

  private def cluster_manifest
    manifest.clusters[cluster_name]? || Manifest::Cluster.new
  end

  private def raw_cluster_manifest
    raw_manifest.clusters[cluster_name]? || Manifest::Cluster.new
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
