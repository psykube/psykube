require "ecr"
require "crouter"
require "http/server"
require "admiral"
require "./concerns/*"
require "../../playground/server"

class Psykube::CLI::Commands::Playground < Admiral::Command
  define_help description: "Start the playground."

  define_flag bind, "The address to bind to.", short: 'b', default: "127.0.0.1"
  define_flag port : Int32, "The port to bind to.", short: 'p', default: 8080

  def run
    Psykube::Playground::Server.listen(port: flags.port, bind: flags.bind)
  end
end
