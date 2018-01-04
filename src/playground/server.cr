require "ecr"
require "orion"
require "http/server"
require "./generate_controller"

router Psykube::Playground::Server do
    use HTTP::ErrorHandler.new
    use HTTP::LogHandler.new

    DUCK = {{ `cat #{__DIR__}/../../psykube-ico.png`.stringify }}

    post "/generate", to: "Generate#generate"

    get "/favicon", accept: "image/png" do |context|
      context.response.content_type = "image/png"
      context.response << DUCK
    end

    get "/duck", accept: "image/png" do |context|
      context.response.content_type = "image/png"
      context.response << DUCK
    end

    get "/app", accept: "application/javascript" do |context|
      context.response.content_type = "application/javascript"
      context.response << {{ `npm run -s build`.stringify }}
    end

    get "/" do |context|
      context.response << {{ `cat #{__DIR__}/index.html`.stringify }}
    end
end
