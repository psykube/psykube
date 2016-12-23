require "./context"
require "./filesystem"
require "./indent_io"
require "./parser"
require "./stringify"
require "./syntax"
require "./util"

  # :nodoc:
class Crustache::Renderer(T)
  def initialize(@open_tag : Slice(UInt8), @close_tag : Slice(UInt8), @context : Context(T), @fs : FileSystem, @out_io : IO)
    @open_tag_default = @open_tag
    @close_tag_default = @close_tag
  end

  def template(t)
    t.content.each &.visit(self)
  end

  def section(s)
    if value = @context.lookup s.value
      case
      when value.is_a?(Indexable)
        value.each do |ctx|
          scope ctx do
            s.content.each &.visit(self)
          end
        end

      when value.is_a?(String -> String)
        io = IO::Memory.new
        t = Syntax::Template.new s.content
        t.visit Stringify.new @open_tag, @close_tag, io
        io = IO::Memory.new value.call io.to_s
        t = Parser.new(@open_tag, @close_tag, io, value.to_s).parse
        io = IO::Memory.new io.size
        t.visit(Renderer.new @open_tag, @close_tag, @context, @fs, io)
        @out_io << io.to_s

      else
        scope value do
          s.content.each &.visit(self)
        end
      end
    end
  end

  def invert(i)
    if value = @context.lookup i.value
      if value.is_a?(Enumerable)
        i.content.each(&.visit(self)) if value.empty?
      end
    else
      i.content.each &.visit(self)
    end
  end

  def output(o)
    if (out_io = @out_io).is_a?(IndentIO)
      out_io.indent_flag_off
    end

    if value = @context.lookup o.value
      if value.is_a?(-> String)
        io = IO::Memory.new value.call
        t = Parser.new(@open_tag_default, @close_tag_default, io, value.to_s).parse
        io = IO::Memory.new io.size
        t.visit(Renderer.new @open_tag_default, @close_tag_default, @context, @fs, io)
        Util.escape io.to_s, @out_io
      else
        Util.escape value.to_s, @out_io
      end
    end

    if (out_io = @out_io).is_a?(IndentIO)
      out_io.indent_flag_on
    end
  end

  def raw(r)
    if (out_io = @out_io).is_a?(IndentIO)
      out_io.indent_flag_off
    end

    if value = @context.lookup r.value
      if value.is_a?(-> String)
        io = IO::Memory.new value.call
        t = Parser.new(@open_tag_default, @close_tag_default, io, value.to_s).parse
        io = IO::Memory.new io.size
        t.visit(Renderer.new @open_tag_default, @close_tag_default, @context, @fs, io)
        @out_io << io.to_s
      else
        @out_io << value.to_s
      end
    end

    if (out_io = @out_io).is_a?(IndentIO)
      out_io.indent_flag_on
    end
  end

  def partial(p)
    if part = @fs.load p.value
      part.visit(Renderer.new @open_tag_default, @close_tag_default, @context, @fs, IndentIO.new(p.indent, @out_io))
    end
  end

  def comment(c); end

  def text(t)
    @out_io << t.value
  end

  def delim(d)
    @open_tag = d.open_tag
    @close_tag = d.close_tag
  end

  private def scope(ctx)
    @context.scope(ctx) do
      yield
    end
  end
end

