require "tempfile"
require "colorize"
require "./psykube/cli"

begin
  Psykube::CLI.run
rescue e
  STDERR.puts "Error: #{e.message}".colorize(:red)
  exit(2)
end
