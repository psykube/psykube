require "openssl"
require "file_utils"
require "crustache"
require "./manifest"
require "./generator/concerns/*"
require "./generator/*"
require "./name_cleaner"

abstract class Psykube::Generator
  class ValidationError < Exception; end

  alias TemplateData = Hash(String, String)

  include Concerns::MetadataHelper

  delegate lookup_port, to: manifest

  @raw_manifest : Manifest::Any?
  @manifest : Manifest::Any?
  @raw_metadata : Hash(String, String)?
  @metadata : Hash(String, String)?
  @git_data : Hash(String, String)?
  @template_yaml : Crustache::Syntax::Template?
  @digest : String?

  getter cluster_name : String
  getter yaml : String = ""
  getter context : String?
  getter namespace : String = "default"
  getter tag : String
  getter image : String
  getter dir : String = "."

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
    @dir = generator.dir
    @manifest = generator.manifest
    @cluster_name = generator.cluster_name
    @context = generator.context
    @namespace = generator.namespace
    @image = generator.image
    @tag = generator.tag
  end

  def initialize(io : IO, cluster_name : String? = nil, context : String? = nil, namespace : String? = nil, image : String? = nil, tag : String? = nil)
    @yaml = String.build { |string_io| IO.copy(io, string_io) }
    @cluster_name = cluster_name || raw_manifest.clusters.keys.first? || "default"
    @context = context || raw_cluster_manifest.context || get_default_context(raw_manifest)
    namespace ||= raw_cluster_manifest.namespace || get_default_namespace(raw_manifest)
    @namespace = NameCleaner.clean(namespace) if namespace
    validate_image!(manifest)
    @tag = tag || get_default_image_tag(cluster_manifest) || get_default_image_tag(manifest) || digest
    @image = image || get_default_image(raw_manifest) || default_image || raise("Image is not specified.")
  end

  def initialize(filename : String, *args, **props)
    if File.directory? File.expand_path filename
      @dir = filename
      filename = File.join(filename, ".psykube.yml")
    else
      @dir = File.dirname filename
    end
    File.open(filename) do |io|
      initialize(io, *args, **props)
    end
  end

  def digest
    @digest ||= get_digest
  end

  def git_data
    @git_data ||= Dir.cd(dir) do
      {"sha" => git_sha, "branch" => git_branch}.tap do |data|
        unless (tag = git_tag).to_s.empty?
          data["tag"] = tag unless tag.empty?
        end
      end
    end
  end

  def raw_metadata
    @raw_metadata ||= {
      "cluster_name" => cluster_name,
      "digest"       => digest,
    }
  end

  def metadata
    @metadata ||= raw_metadata.merge({"namespace" => namespace})
  end

  def template_result(metadata : Hash(String, String) = raw_metadata)
    Crustache.render template_yaml, {
      "metadata" => metadata,
      "git"      => git_data,
      "env"      => env_hash,
    }
  end

  def raw_manifest
    @raw_manifest ||= Manifest::Any.from_yaml(template_result)
  rescue e : YAML::ParseException
    raise ParseException.new(template_result, e)
  end

  def manifest
    @manifest ||= Manifest::Any.from_yaml(template_result metadata)
  rescue e : YAML::ParseException
    raise ParseException.new(template_result, e)
  end

  def validate_image!(manifest : Manifest::V1) : Nil
    if manifest.image && registry_user
      raise "Cannot specify both `image` and `registry` infromation in the same manifest!"
    end
  end

  def validate_image!(manifest) : Nil
  end

  def image(tag)
    image.sub(/:.+$/, ":" + tag)
  end

  def registry_host
    cluster_manifest.registry_host || manifest.registry_host
  end

  def registry_user
    cluster_manifest.registry_user || manifest.registry_user
  end

  def name
    [prefix, manifest.name, suffix].compact.join
  end

  def prefix
    cluster_manifest.prefix || manifest.prefix
  end

  def suffix
    cluster_manifest.suffix || manifest.suffix
  end

  def to_yaml(*args, **props)
    result.to_yaml(*args, **props)
  end

  def to_json(*args, **props)
    result.to_json(*args, **props)
  end

  abstract def result

  private def env_hash
    ENV.keys.each_with_object({} of String => String) { |k, h| h[k] = ENV[k] }.reject { |k, v| v.empty? }
  end

  private def default_image
    [registry_host, registry_user, name].compact.join('/') + ":" + @tag
  end

  private def template_yaml
    @template_yaml ||= Crustache.parse yaml.gsub(/<<(.+)>>/, "{{\\1}}")
  end

  private def cluster_manifest
    manifest.clusters[cluster_name]? || Manifest::V1::Cluster.new
  end

  private def raw_cluster_manifest
    raw_manifest.clusters[cluster_name]? || Manifest::V1::Cluster.new
  end

  private def cluster_config_map
    manifest.config_map.merge cluster_manifest.config_map
  end

  private def cluster_secrets
    manifest.secrets.merge cluster_manifest.secrets
  end

  private def manifest_env
    manifest.env || {} of String => String | Manifest::V1::Env
  end

  private def get_default_context(manifest : Manifest::V2::Any)
    manifest.default_context
  end

  private def get_default_namespace(manifest : Manifest::V2::Any)
    manifest.default_namespace
  end

  private def get_default_image(manifest : Manifest::V2::Any)
    nil
  end

  private def get_default_image_tag(manifest : Manifest::V2::Any)
    nil
  end

  private def get_default_image_tag(manifest : Manifest::V2::Shared::Cluster)
    nil
  end

  private def get_default_namespace(manifest : Manifest::V1)
    manifest.image
  end

  private def get_default_image_tag(manifest : Manifest::V1 | Manifest::V1::Cluster)
    manifest.image_tag
  end

  private def get_default_image(manifest : Manifest::V1)
    manifest.image
  end

  private def get_default_namespace(manifest : Manifest::V1)
    manifest.namespace
  end

  private def get_default_context(manifest : Manifest::V1)
    manifest.context
  end

  private def get_digest(kind : String = "sha256")
    files = Concerns::IgnoreParser.new(".dockerignore", dir).filter.reject { |f| File.directory? f }
    hexdigest = files.each_with_object(OpenSSL::Digest.new(kind)) do |file, digest|
      File.open(file) do |f|
        digest.update(f)
      end
    end.hexdigest
    "#{kind}-#{hexdigest}"
  end

  private def git_branch
    ENV["TRAVIS_BRANCH"]? ||
      ENV["CIRCLE_BRANCH"]? ||
      `git rev-parse --abbrev-ref HEAD`.strip
  end

  private def git_sha
    ENV["TRAVIS_COMMIT"]? ||
      ENV["CIRCLE_SHA1"]? ||
      `git rev-parse HEAD`.strip
  end

  private def git_tag
    ENV["TRAVIS_TAG"]? ||
      ENV["CIRCLE_TAG"]? ||
      `git describe --exact-match --abbrev=0 --tags 2> /dev/null`.strip
  end
end
