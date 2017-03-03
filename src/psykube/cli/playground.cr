require "ecr"
require "crouter"
require "http/server"
require "admiral"
require "./concerns/*"
{% system "npm install" %}

class Psykube::Commands::Playground < Admiral::Command
  struct GenerateController
    private getter context : HTTP::Server::Context
    private getter params : HTTP::Params

    def initialize(@context, @params)
    end

    def generate
      if (body = context.request.body)
        Psykube::Generator::List.new(body).to_json(context.response)
      end
    rescue e : YAML::ParseException
      context.response.status_code = 422
      context.response << e.message
    end
  end

  class Router < Crouter::Router
    post "/generate", "GenerateController#generate"

    get "/app.js" do
      context.response.content_type = "application/js"
      context.response << {{ `npm run -s build`.stringify }}
    end

    get "/" do
      context.response << {{ `cat #{__DIR__}/playground/index.html`.stringify }}
    end
  end

  define_help description: "Start the playground."

  define_flag bind, "The address to bind to.", short: 'b', default: "127.0.0.1"
  define_flag port : Int32, "The port to bind to.", short: 'p', default: 8080

  def run
    handlers = [
      HTTP::ErrorHandler.new,
      HTTP::LogHandler.new,
      Router.new,
    ]
    puts "Listening on #{flags.bind}:#{flags.port}"
    HTTP::Server.new(flags.bind, flags.port, handlers).listen
  end
end
