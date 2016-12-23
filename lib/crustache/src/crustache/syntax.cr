module Crustache::Syntax
  abstract class Node
    def initialize; end

    macro inherited
      @[AlwaysInline]
      def visit(v) : Nil
        v.{{ @type.name.gsub(/^.+::/, "").downcase.id }}(self)
        nil
      end
    end
  end

  class Template < Node
    getter content

    def initialize(@content = [] of Node); end

    def <<(data)
      unless data.is_a?(Text) && data.value.not_nil!.empty?
        @content << data
      end
      self
    end

    def to_code(io)
      io << "::Crustache::Syntax::Template.new(["
      flag = false
      @content.each do |node|
        io << ", " if flag
        node.to_code(io)
        flag = true
      end
      io << "] of ::Crustache::Syntax::Node)"
    end
  end

  module Tag
    getter! value

    def initialize(@value : String); super() end

    macro def to_code(io) : Nil
      {% begin %}
        io << "::{{ @type.name.id }}.new("
        @value.inspect io
        io << ")"
        nil
      {% end %}
    end
  end

  {% for type in %w(Section Invert) %}
    class {{ type.id }} < Template
      include Tag

      def initialize(@value : String, @content = [] of Node); end

      macro def to_code(io) : Nil
        \{% begin %}
          io << "::\{{ @type.name.id }}.new("
          @value.inspect io
          io << ", ["
          flag = false
          @content.each do |node|
            io << ", " if flag
            node.to_code(io)
            flag = true
          end
          io << "] of ::Crustache::Syntax::Node)"
          nil
        \{% end %}
      end
    end
  {% end %}

  {% for type in %w(Output Raw Comment Text) %}
    class {{ type.id }} < Node
      include Tag
    end
  {% end %}

  class Partial < Node
    getter indent
    getter value

    def initialize(@indent : String, @value : String); end

    def to_code(io)
      io << "::Crustache::Syntax::Partial.new("
      @indent.inspect io
      io << ", "
      @value.inspect io
      io << ")"
    end
  end

  class Delim < Node
    getter open_tag
    getter close_tag

    def initialize(@open_tag : Slice(UInt8), @close_tag : Slice(UInt8)); end

    def to_code(io)
      io << "::Crustache::Syntax::Delim.new("
      String.new(@open_tag).inspect io; io << ".to_slice"
      io << ", "
      String.new(@close_tag).inspect io; io << ".to_slice"
      io << ")"
    end
  end
end
