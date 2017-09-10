require "ecr"
require "crouter"
require "http/server"
require "./router"
require "./generate_controller"

struct Psykube::Playground::Server
  def self.listen(**options)
    new(**options).listen
  end

  def initialize(**options, @port = 8080, @bind = "127.0.0.1"); end

  def listen
    handlers = [
      HTTP::ErrorHandler.new,
      HTTP::LogHandler.new,
      Router.new,
    ]
    puts "Listening on #{@bind}:#{@port}"
    HTTP::Server.new(@bind, @port, handlers).listen
  end
end
