module Psykube::Manifest
  alias Any = V1::Manifest | V2::Manifest

  class TypeMatcher
    YAML.mapping({type: String?})
  end

  class VersionMatcher
    YAML.mapping({version: Int32?})
  end

  def self.from_yaml(string_or_io : String | IO) : Any
    new(YAML::ParseContext.new, parse_yaml(string_or_io))
  end

  def self.new(ctx : YAML::ParseContext, node : YAML::Nodes::Node)
    case (version = VersionMatcher.new(ctx, node).version)
    when 1, nil
      V1::Manifest.new(ctx, node)
    when 2
      V2::Manifest.new(ctx, node)
    else
      node.raise "Invalid manifest version: #{version}"
    end
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
