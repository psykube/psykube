require "./syntax"
require "./util"

# :nodoc:
class Crustache::Parser
  CURLY_START = '{'.ord.to_u8
  CURLY_END = '}'.ord.to_u8
  AMP = '&'.ord.to_u8
  EQ = '='.ord.to_u8
  GT = '>'.ord.to_u8
  HASH = '#'.ord.to_u8
  HAT = '^'.ord.to_u8
  SLASH = '/'.ord.to_u8
  BANG = '!'.ord.to_u8
  NEWLINE_N = '\n'.ord.to_u8
  NEWLINE_R = '\r'.ord.to_u8
  EQ_SLICE = Slice(UInt8).new(1){EQ}
  CURLY_END_SLICE = Slice(UInt8).new(1){CURLY_END}

  def initialize(@open_tag : Slice(UInt8), @close_tag : Slice(UInt8), @io : IO, @filename : String, @row : Int32 = 1)
    @peek = 0_u8
    @peek_flag = false

    @save_row = @row

    @text_io = IO::Memory.new
    @value_io = IO::Memory.new

    @line_flag = true
  end

  def parse
    tmpl = Syntax::Template.new
    tmpl_stack = [] of Syntax::Template
    open_tag = @open_tag
    close_tag = @close_tag

    while scan_until open_tag, @text_io
      save_row

      case peek
      when CURLY_START # raw output `{{{value}}}`
        read
        parse_error "Unclosed tag" unless scan_until CURLY_END_SLICE, @value_io
        parse_error "Unclosed tag" unless scan close_tag

        tmpl << Syntax::Text.new get_text
        tmpl << Syntax::Raw.new get_value.strip

      when EQ          # set delimiter `{{=| |=}}`
        read
        parse_error "Unclosed tag" unless scan_until EQ_SLICE, @value_io
        parse_error "Unclosed tag" unless scan close_tag

        tmpl << Syntax::Text.new(get_text_as_standalone)
        value = get_value.strip
        delim = value.split(/\s+/, 2)
        parse_error "Invalid delmiter #{value.inspect}" if delim[0].match(/\s|=/)
        parse_error "Invalid delimiter #{value.inspect}" if delim[1].match(/\s|=/)

        open_tag = delim[0].to_slice
        close_tag = delim[1].to_slice
        tmpl << Syntax::Delim.new open_tag, close_tag

      when HASH        # section open `{{#value}}`
        read
        parse_error "Unclosed tag" unless scan_until close_tag, @value_io

        tmpl << Syntax::Text.new get_text_as_standalone
        tmpl = Syntax::Section.new(get_value.strip).tap{|t| tmpl_stack << (tmpl << t)}

      when HAT         # invert section open `{{^value}}`
        read
        parse_error "Unclosed tag" unless scan_until close_tag, @value_io

        tmpl << Syntax::Text.new get_text_as_standalone
        tmpl = Syntax::Invert.new(get_value.strip).tap{|t| tmpl_stack << (tmpl <<  t)}

      when SLASH       # section close `{{/value}}`
        read
        parse_error "Unclosed tag" unless scan_until close_tag, @value_io

        tmpl << Syntax::Text.new get_text_as_standalone
        value = get_value.strip
        if tmpl_stack.empty? || value != tmpl.as(Syntax::Tag).value
          parse_error "Unopened tag #{value.inspect}"
        end
        tmpl = tmpl_stack.pop

      when AMP         # raw output `{{&value}}`
        read
        parse_error "Unclosed tag" unless scan_until close_tag, @value_io

        tmpl << Syntax::Text.new get_text
        tmpl << Syntax::Raw.new get_value.strip

      when BANG        # comment `{{!value}}`
        read
        parse_error "Unclosed tag" unless scan_until close_tag, @value_io

        tmpl << Syntax::Text.new get_text_as_standalone
        tmpl << Syntax::Comment.new get_value

      when GT          # partial `{{>partial}}`
        read
        parse_error "Unclosed tag" unless scan_until close_tag, @value_io

        text, indent = get_text_as_standalone_with_indent
        tmpl << Syntax::Text.new text
        tmpl << Syntax::Partial.new indent, get_value.strip

      else             # output `{{value}}`
        parse_error "Unclosed tag" unless scan_until close_tag, @value_io

        tmpl << Syntax::Text.new get_text
        tmpl << Syntax::Output.new get_value.strip

      end
    end

    unless tmpl_stack.empty?
      save_row
      parse_error "Unclosed section #{tmpl.as(Syntax::Tag).value.inspect}"
    end

    tmpl << Syntax::Text.new get_text

    tmpl
  end

  private def read
    if @peek_flag
      @peek_flag = false
      return @peek
    end

    if c = @io.read_byte
      if c == NEWLINE_N
        @line_flag = true
        @row += 1
      end
      c
    else
      nil
    end
  end

  private def peek
    if c = read
      @peek = c
      @peek_flag = true
      c
    else
      nil
    end
  end

  private def scan(tag)
    i = 0
    size = tag.size
    while i < size
      unless read == tag[i]
        return false
      end
      i += 1
    end

    return true
  end

  private def scan_until(tag, out_io)
    i = 0
    size = tag.size
    text = Slice(UInt8).new size
    while i < size
      if c = read
        text[i] = c
      else
        out_io.write text[0, i]
        return false
      end
      i += 1
    end

    until text.to_unsafe.memcmp(tag.to_unsafe, size) == 0
      out_io.write_byte text[0]
      text.to_unsafe.copy_from((text + 1).to_unsafe, size - 1)
      if c = read
        text[size - 1] = c
      else
        out_io.write text[0, size - 1]
        return false
      end
    end

    return true
  end

  private def parse_error(mes)
    raise ParseError.new(mes, @filename, @save_row)
  end

  private def save_row
    @save_row = @row
  end

  private def get_text
    @line_flag = false
    @text_io.to_s.tap{@text_io.clear}
  end

  private def get_value
    @value_io.to_s.tap{@value_io.clear}
  end

  private def get_text_as_standalone
    get_text_as_standalone_with_indent[0]
  end

  private def get_text_as_standalone_with_indent
    unless @line_flag
      return {get_text, ""}
    end

    text = get_text
    i = text.size - 1
    while i >= 0
      case text[i]
      when ' ', '\t'
        i -= 1
        next
      when '\n'
        break
      else
        return {text, ""}
      end
    end

    i += 1
    case peek
    when NEWLINE_N
      read
      return {text[0, i], text[i..-1]}
    when NEWLINE_R
      read
      if peek == NEWLINE_N
        read
        return {text[0, i], text[i..-1]}
      else
        @text_io.write_byte NEWLINE_R
        return {text, ""}
      end
    when nil
      return {text[0, i], text[i..-1]}
    else
      return {text, ""}
    end
  end
end
