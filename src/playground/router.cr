{% system "npm install" %}

class Psykube::Playground::Router < Crouter::Router
  DUCK = {{ `cat #{__DIR__}/../../psykube-ico.png`.stringify }}

  post "/generate", "GenerateController#generate"

  get "/favicon.png" do
    context.response.content_type = "image/png"
    context.response << DUCK
  end

  get "/duck.png" do
    context.response.content_type = "image/png"
    context.response << DUCK
  end

  get "/app.js" do
    context.response.content_type = "application/js"
    context.response << {{ `npm run -s build`.stringify }}
  end

  get "/" do
    context.response << {{ `cat #{__DIR__}/index.html`.stringify }}
  end
end
