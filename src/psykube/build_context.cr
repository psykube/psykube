class Psykube::BuildContext
  record Login, server : String, username : String, password : String

  property tag : String?
  getter build_tags : Array(String)
  getter cache_from : Array(String)
  setter image : String
  getter container_name : String
  getter build : Bool
  getter context : String
  getter dockerfile : String?
  getter args : Array(String)
  getter login : Login?

  def initialize(*, @container_name : String, image : String, tag, @context, @dockerfile, @build, args, @login = nil, cache_from = nil, build_tags = nil)
    parts = image.split(':')
    @image = parts[0]
    tag ||= parts[1]?
    @tag = tag
    @build_tags = parse_build_tags(build_tags).compact.reject(&.empty?)
    @build_tags.unshift(tag) if (tag)
    @cache_from = parse_cache_from(cache_from).compact.reject(&.empty?)
    @args = args.map &.join('=')
  end

  def image(tag = nil)
    base_image = build ? [@image, container_name].join('-') : @image
    tag ||= @tag
    [base_image, tag].compact.join(':')
  end

  private def parse_cache_from(value : String | Array(String) | Nil)
    parse_array_opts(value)
  end

  private def parse_cache_from(value : V2::Manifest::Shared::Container::Build::CacheFromTag)
    [parse_cache_from_value(value)]
  end

  private def parse_cache_from(values : Array(V2::Manifest::Shared::Container::Build::CacheFromTag | String))
    values.map do |value|
      parse_cache_from_value(value)
    end
  end

  def parse_cache_from_value(value : V2::Manifest::Shared::Container::Build::CacheFromTag)
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
