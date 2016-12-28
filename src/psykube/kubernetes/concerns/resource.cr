require "./mapping"
require "../shared/metadata"

module Psykube::Kubernetes::Resource
  macro definition(api_version, kind, properties)
    # Add resource props
    {% properties[:api_version] = {type: String, default: api_version} %}
    {% properties[:kind] = {type: String, default: kind} %}
    {% properties[:metadata] = {type: Shared::Metadata} %}

    def initialize(name : String)
      initialize
      @metadata = Shared::Metadata.new(name)
    end

    def name
      @metadata.name
    end

    Kubernetes.mapping({{properties}})
  end

  macro definition(api_version, kind, **properties)
    Resource.mapping(api_version, kind, {{properties}})
  end
end
