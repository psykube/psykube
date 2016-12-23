require "./syntax"

module Crustache
  # :nodoc:
  class Stringify
    def initialize(@open_tag : Slice(UInt8), @close_tag : Slice(UInt8), @io : IO); end

    def template(t)
      t.content.each &.visit(self)
    end

    def section(s)
      @io.write @open_tag
      @io << "#" << s.value
      @io.write @close_tag
      s.content.each &.visit(self)
      @io.write @open_tag
      @io << "/" << s.value
      @io.write @close_tag
    end

    def invert(i)
      @io.write @open_tag
      @io << "#" << i.value
      @io.write @close_tag
      i.content.each &.visit(self)
      @io.write @open_tag
      @io << "/" << i.value
      @io.write @close_tag
    end

    def output(o)
      @io.write @open_tag
      @io << o.value
      @io.write @close_tag
    end

    def raw(r)
      @io.write @open_tag
      @io << "&" << r.value
      @io.write @close_tag
    end

    def partial(p)
      @io.write @open_tag
      @io << ">" << p.value
      @io.write @close_tag
    end

    def comment(c)
      @io.write @open_tag
      @io << "!" << c.value
      @io.write @close_tag
    end

    def text(t)
      @io << t.value
    end

    def delim(d)
      @io.write @open_tag
      @io << "="
      @io.write d.open_tag
      @io << " "
      @io.write d.close_tag
      @io << "="
      @io.write @close_tag

      @open_tag = d.open_tag
      @close_tag = d.close_tag
    end
  end
end
