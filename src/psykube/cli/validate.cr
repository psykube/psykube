require "admiral"
require "./concerns/*"

class Psykube::Commands::Validate < Admiral::Command
  include PsykubeFileFlag

  define_help description: "Inspect the template result."

  def cluster_name
    "default"
  end

  def run
    puts generator.template_result
    puts ""
    puts "Template OK".colorize(:green)
  rescue e : Psykube::ParseException
    panic e.message
  end
end
