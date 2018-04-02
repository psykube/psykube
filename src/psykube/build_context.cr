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
    @tag = tag || get_digest
    @args = args.map &.join('=')
  end

  def image(tag = nil)
    [@image, tag || @tag].join(':')
  end

  private def get_digest(kind : String = "sha256")
    files = IgnoreParser.new(".dockerignore", context).filter.reject { |f| File.directory? f }
    hexdigest = files.each_with_object(OpenSSL::Digest.new(kind)) do |file, digest|
      File.open(file) do |f|
        digest.update(f)
      end
    end.hexdigest
    "#{kind}-#{hexdigest}"
  end

  def_equals @image, @build, @tag, @context, @dockerfile, @args
end
