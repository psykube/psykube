module Psykube
  class Error < Exception
  end

  class ParseException < YAML::ParseException
    def puts(io : IO)
      col = column_number - 1
      err = col > 0 ? (" " * col) + "^ " + message.to_s : message.to_s
      lines.insert(error.line_number, err.colorize(:red).to_s)
      lines.unshift "Error: Could not parse\n".colorize(:red).to_s
      io.puts lines.join("\n")
    end
  end

  class TypeException < ParseException
  end
end
