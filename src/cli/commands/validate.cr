require "./concerns/*"

class Psykube::CLI::Commands::Validate < Admiral::Command
  include PsykubeFileFlag

  define_help description: "Inspect the template result."

  define_flag recursive : Bool, description: "Validate all the psykube files from the directory and its decendants", short: 'R'
  define_flag verbose : Bool, description: "Print the template(s) as they are validated", short: 'V'

  def cluster_name
    "default"
  end

  def run
    if flags.recursive
      invalid = [] of String
      Dir.glob("./**/*/.psykube.yml") do |path|
        begin
          validate_template Actor.new(self, path)
        rescue error
          @error_io.puts "ERROR | #{path} (#{error})".colorize(:red)
          invalid << path
        end
      end
      panic "ERROR | invalid files: #{invalid.join(", ")}".colorize(:red) unless invalid.empty?
    else
      begin
        validate_template actor
      rescue error
        @error_io.puts "ERROR | #{actor.filename} (#{error})".colorize(:red)
      end
    end
  end

  def validate_template(actor : Actor)
    result = actor.template_result
    if flags.verbose
      puts result
      puts ""
    end
    puts "   OK | #{actor.filename}".colorize(:green)
  end
end
