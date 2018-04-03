module Psykube
  class Error < Exception
  end

  class ParseException < Error
    getter line_number : Int32
    getter column_number : Int32

    def initialize(message, line_number, column_number, context_info = nil)
      @line_number = line_number.to_i
      @column_number = column_number.to_i
      if context_info
        context_msg, context_line, context_column = context_info
        super("#{message} at line #{line_number}, column #{column_number}, #{context_msg} at line #{context_line}, column #{context_column}")
      else
        super("#{message} at line #{line_number}, column #{column_number}")
      end
    end

    def location
      {line_number, column_number}
    end

    def puts(io : IO)
      col = column_number - 1
      err = col > 0 ? (" " * col) + "^ " + message.to_s : message.to_s
      lines.insert(error.line_number, err.colorize(:red).to_s)
      lines.unshift "Error: Could not parse\n".colorize(:red).to_s
      io.puts lines.join("\n")
    end
  end

  class VersionException < ParseException
  end

  class TypeException < ParseException
  end
end
