class Psykube::Actor
  @digest : String?
  @git_data : Hash(String, String)?
  @metadata : Hash(String, String)?
  @raw_metadata : Hash(String, String)?
  @raw_manifest : Manifest::Any?
  @manifest : Manifest::Any?
  @template : Crustache::Syntax::Template
  @build_contexts : Array(BuildContext)?
  getter cluster_name : String
  getter basename : String
  getter tag : String
  getter context : String? = nil
  getter namespace : String = "default"
  getter dir : String = "."

  delegate to_json, to: generate

  def initialize(io, cluster_name = nil, context = nil, namespace = nil, basename = nil, tag = nil)
    raw_yaml = String.build { |string_io| IO.copy(io, string_io) }
    @template = Crustache.parse raw_yaml
    @cluster_name = cluster_name || "default"
    @tag = tag || get_tag
    @basename = basename || get_basename
    @namespace = namespace || cluster.namespace || manifest.namespace || "default"
    @context = context || cluster.context || manifest.context
  end

  def initialize(command : Admiral::Command)
    flags = command.flags
    arguments = command.arguments
    filename = flags.file
    if File.directory? File.expand_path filename
      @dir = filename
      filename = File.join(filename, ".psykube.yml")
    else
      @dir = File.dirname filename
    end
    File.open(filename) do |io|
      initialize(
        io: io,
        cluster_name: arguments.responds_to?(:cluster) ? arguments.cluster : nil,
        context: arguments.responds_to?(:context) ? arguments.context : nil,
        namespace: arguments.responds_to?(:namespace) ? arguments.namespace : nil,
        basename: arguments.responds_to?(:image) ? arguments.image : nil,
        tag: arguments.responds_to?(:tag) ? arguments.tag : nil,
      )
    end
  end

  def cluster
    manifest.get_cluster(cluster_name)
  end

  def digest
    @digest ||= get_digest
  end

  def generate : Pyrite::Api::Core::V1::List
    manifest.generate(self)
  end

  def build_contexts
    @build_contexts ||= manifest.get_build_contexts(basename: basename, tag: @tag)
  end

  def manifest
    @manifest ||= Manifest::Any.from_yaml(template_result metadata)
  rescue e : YAML::ParseException
    raise ParseException.new(template_result, e)
  end

  def name
    NameCleaner.clean([prefix, manifest.name, suffix].compact.join)
  end

  def template_result(metadata : Hash(String, String) = raw_metadata)
    Crustache.render @template, {
      "metadata" => metadata,
      "git"      => git_data,
      "env"      => env_hash,
    }
  end

  private def ci_branch
    ENV["TRAVIS_BRANCH"]? || ENV["CIRCLE_BRANCH"]?
  end

  private def ci_sha
    ENV["TRAVIS_COMMIT"]? || ENV["CIRCLE_SHA1"]?
  end

  private def ci_tag
    ENV["TRAVIS_TAG"]? || ENV["CIRCLE_TAG"]?
  end

  private def env_hash
    ENV.keys.each_with_object({} of String => String) { |k, h| h[k] = ENV[k] }.reject { |k, v| v.empty? }
  end

  private def git_data
    @git_data ||= Dir.cd(dir) do
      {"sha" => git_sha, "branch" => git_branch}.tap do |data|
        unless (tag = git_tag).to_s.empty?
          data["tag"] = tag unless tag.empty?
        end
      end
    end
  end

  private def get_digest(kind : String = "sha256")
    files = IgnoreParser.new(".dockerignore", dir).filter.reject { |f| File.directory? f }
    hexdigest = files.each_with_object(OpenSSL::Digest.new(kind)) do |file, digest|
      File.open(file) do |f|
        digest.update(f)
      end
    end.hexdigest
    "#{kind}-#{hexdigest}"
  end

  private def git_branch
    ci_branch || `git rev-parse --abbrev-ref HEAD`.strip
  end

  private def git_sha
    ci_sha || `git rev-parse HEAD`.strip
  end

  private def git_tag
    ci_tag || `git describe --exact-match --abbrev=0 --tags 2> /dev/null`.strip
  end

  private def get_tag
    m = manifest
    case m
    when V1::Manifest
      cluster.image_tag || m.image_tag
    end || digest
  end

  private def get_basename
    m = manifest
    case m
    when V1::Manifest
      m.image
    end || [registry_host, registry_user, name].compact.join('/')
  end

  private def metadata
    return raw_metadata if !@manifest
    @metadata ||= raw_metadata.merge({"namespace" => namespace})
  end

  private def prefix
    cluster.prefix || manifest.prefix
  end

  private def raw_manifest
    @raw_manifest ||= Manifest::Any.from_yaml(template_result)
  rescue e : YAML::ParseException
    raise ParseException.new(template_result, e)
  end

  private def raw_metadata
    @raw_metadata ||= {
      "cluster_name" => @cluster_name,
      "digest"       => digest,
    }
  end

  private def registry_host
    cluster.registry_host || manifest.registry_host
  end

  private def registry_user
    cluster.registry_user || manifest.registry_user
  end

  private def suffix
    cluster.suffix || manifest.suffix
  end
end
