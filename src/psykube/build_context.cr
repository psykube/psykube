struct Psykube::BuildContext
  @image : String
  getter tag : String
  getter context : String
  getter dockerfile : String?
  getter args : Array(String)

  def initialize(*, @image, @tag, @context, @dockerfile, args)
    @args = args.map &.join('=')
  end

  def image(tag = nil)
    [@image, tag || @tag].join(':')
  end
end
