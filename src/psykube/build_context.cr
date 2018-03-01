struct Psykube::BuildContext
  @image : String
  getter build : Bool
  getter tag : String
  getter context : String
  getter dockerfile : String?
  getter args : Array(String)

  def initialize(*, @image, @tag, @context, @dockerfile, @build, args)
    @args = args.map &.join('=')
  end

  def image(tag = nil)
    [@image, tag || @tag].join(':')
  end
end
