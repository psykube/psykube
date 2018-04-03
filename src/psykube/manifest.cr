module Psykube::Manifest
  alias Any = V1::Manifest | V2::Manifest

  def self.from_yaml(string_or_io : String | IO) : Any
    new(YAML::ParseContext.new, parse_yaml(string_or_io))
  end

  def self.new(ctx : YAML::ParseContext, node : YAML::Nodes::Node)
    V2::Manifest.new(ctx, node)
  rescue VersionException
    V1::Manifest.new(ctx, node)
  end

  private def self.parse_yaml(string_or_io)
    document = YAML::Nodes.parse(string_or_io)

    # If the document is empty we simulate an empty scalar with
    # plain style, that parses to Nil
    document.nodes.first? || begin
      scalar = YAML::Nodes::Scalar.new("")
      scalar.style = YAML::ScalarStyle::PLAIN
      scalar
    end
  end
end
