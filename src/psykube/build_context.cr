class Psykube::BuildContext
  record Login, server : String, username : String, password : String

  property tag : String?
  setter image : String
  getter container_name : String
  getter build : Bool
  getter context : String
  getter dockerfile : String?
  getter cache_from : String?
  getter args : Array(String)
  getter login : Login?

  def initialize(*, @container_name : String, @image : String, tag : String?, @context, @dockerfile, @build, args, @login = nil, @cache_from = nil)
    parts = image.split(':')
    image = parts[0]
    tag = parts[1]? || tag
    @tag = tag if tag.to_s.size > 0
    @args = args.map &.join('=')
  end

  def image(tag = nil)
    base_image = build ? [@image, container_name].join('-') : @image
    tag ||= @tag
    [base_image, tag].compact.join(':')
  end

  def_equals @image, @build, @tag, @context, @dockerfile, @args
end
