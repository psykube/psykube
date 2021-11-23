require "./concerns/git_data"

class Psykube::BuildContext
  include GitData

  record Login, server : String, username : String, password : String

  @cache_from : Array(String)

  property tag : String?
  getter build_tags : Array(String)
  setter image : String
  getter container_name : String
  getter build : Bool
  getter context : String
  getter dockerfile : String?
  getter args : Array(String)
  getter login : Login?
  getter stages : Array(String)
  getter target : String?
  getter platform : String

  def initialize(*, @container_name : String, image : String, tag, @context, @dockerfile, @build, args, @login = nil, cache_from = nil, build_tags = nil, @stages = [] of String, @target = nil, @platform : String)
    parts = image.split(':')
    @image = parts[0]
    tag ||= parts[1]?
    @tag = tag || default_tag
    @build_tags = parse_build_tags(build_tags).compact.reject(&.empty?).uniq!
    @build_tags.unshift(tag) if (tag)
    @cache_from = parse_cache_from(cache_from).compact.reject(&.empty?).uniq!
    @args = args.map &.join('=')
  end

  def image(tag = nil)
    base_image = build ? [@image, container_name].join('-') : @image
    tag ||= @tag
    [base_image, tag].compact.join(':')
  end

  def default_tag
    case ENV["PSYKUBE_TAG_STRATEGY"]?
    when "git"
      return "git-tag-#{git_tag}" if git_tag
      return "git-sha-#{git_sha}" if git_sha
    end
  end

  def cache_from
    (@build_tags + @cache_from).uniq
  end

  private def parse_cache_from(value : String | Array(String) | Nil)
    parse_array_opts(value)
  end

  private def parse_cache_from(value : Manifest::Shared::Container::Build::CacheFromTag)
    [parse_cache_from_value(value)]
  end

  private def parse_cache_from(values : Array(Manifest::Shared::Container::Build::CacheFromTag | String))
    values.map do |value|
      parse_cache_from_value(value)
    end
  end

  def parse_cache_from_value(value : Manifest::Shared::Container::Build::CacheFromTag)
    [image, value.tag].join(":") unless value.tag.empty?
  end

  def parse_cache_from_value(value : String)
    value
  end

  private def parse_build_tags(opts)
    parse_array_opts(opts).reject(&.empty?).map do |tag|
      image(tag)
    end
  end

  private def parse_array_opts(none : Nil)
    [] of String
  end

  private def parse_array_opts(one : String)
    [one]
  end

  private def parse_array_opts(many : Array(String))
    many
  end

  def_equals @image, @build, @tag, @context, @dockerfile, @args
end
