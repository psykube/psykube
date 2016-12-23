require "./parser"

# :nodoc:
class Crustache::IndentIO
  include IO

  def initialize(@indent : String, @io : IO)
    @indent_flag = 0
    @eol_flag = true
  end

  def indent_flag_on
    @indent_flag -= 1
  end

  def indent_flag_off
    @indent_flag += 1
  end

  def read(s : Slice(UInt8))
    raise "Unsupported"
  end

  def write(s)
    start = 0
    size = s.size
    i = 0
    while i < size
      if @eol_flag
        @io.write s[start, i - start]
        @io << @indent
        @eol_flag = false
        start = i
      end

      if s[i] == Parser::NEWLINE_N && @indent_flag == 0
        @eol_flag = true
      end

      i += 1
    end

    @io.write s[start, i - start]
  end
end
