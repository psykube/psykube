struct Psykube::Playground::GenerateController
  include Orion::ControllerHelper

  def generate
    data = begin
      body = context.request.body || IO::Memory.new
      actor = Actor.new(body)
      actor.cluster_name = context.request.query_params["cluster"]? || actor.clusters.keys.first
      {
        result: actor.generate.to_yaml,
        clusters: actor.clusters.keys,
        current_cluster: actor.cluster_name
      }
    rescue e : Psykube::Error | YAML::ParseException
      context.response.status_code = 422
      { error: e.message }
    end

    data.to_json(context.response)
  end
end
