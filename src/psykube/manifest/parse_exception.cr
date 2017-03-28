class Psykube::Manifest::ParseException < Exception
  getter source : String = ""

  def initialize(template : String, error : YAML::ParseException)
    lines = template.lines
    col = error.column_number - 1
    err = col > 0 ? (" " * col) + "^ " + error.message.to_s : error.message.to_s
    lines.insert(error.line_number, err.colorize(:red).to_s)
    lines.unshift "Error: Could not parse manifest\n".colorize(:red).to_s
    initialize lines.join("\n")
  end
end
