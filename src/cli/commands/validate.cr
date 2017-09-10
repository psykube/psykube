require "admiral"
require "./concerns/*"

class Psykube::CLI::Commands::Validate < Admiral::Command
  include PsykubeFileFlag

  define_help description: "Inspect the template result."

  def cluster_name
    "default"
  end

  def run
    puts generator.template_result
    puts ""
    puts "Template OK".colorize(:green)
  end
end
