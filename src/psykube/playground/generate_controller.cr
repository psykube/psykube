struct Psykube::Playground::GenerateController
  private getter context : HTTP::Server::Context
  private getter params : HTTP::Params

  def initialize(@context, @params)
  end

  def generate
    if (body = context.request.body)
      gen = Generator::List.new(body)
      gen.to_json(context.response)
    end
  rescue e : Psykube::ParseException | Crustache::ParseError | Generator::ValidationError | ArgumentError
    context.response.status_code = 422
    context.response << e.message
  end
end
