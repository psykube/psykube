struct Psykube::BuildContext
  @image : String
  getter build : Bool
  getter tag : String
  getter context : String
  getter dockerfile : String?
  getter args : Array(String)

  def initialize(*, image : String, tag : String?, @context, @dockerfile, @build, args)
    parts = image.split(':')
    image = parts[0]
    tag = parts[1]? || tag || "latest"
    @image = image
    @tag = tag
    @args = args.map &.join('=')
  end

  def image(tag = nil)
    [@image, tag || @tag].join(':')
  end

  def_equals @image, @build, @tag, @context, @dockerfile, @args
end
