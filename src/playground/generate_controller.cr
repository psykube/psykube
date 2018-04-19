struct Psykube::Playground::GenerateController
  include Orion::ControllerHelper

  def generate
    if (body = context.request.body)
      gen = Actor.new(body).generate
      gen.to_yaml(context.response)
    end
  rescue e : Psykube::Error | YAML::ParseException
    context.response.status_code = 422
    context.response << e.message
  end
end
