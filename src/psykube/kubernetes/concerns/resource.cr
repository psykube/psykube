require "./mapping"
require "../shared/metadata"

module Psykube::Kubernetes::Resource
  private TIMESTAMP = Time::Format::ISO_8601_DATE_TIME.format(Time.utc_now)

  macro definition(api_version, kind, properties)
    # Add resource props
    {% properties[:api_version] = {type: String, default: api_version} %}
    {% properties[:kind] = {type: String, default: kind} %}
    {% properties[:metadata] = {type: Shared::Metadata} %}

    def initialize(name : String)
      initialize
      @metadata = Shared::Metadata.new(name)
      (@metadata.labels ||= {} of String => String)["psykube"] = "true"
      (@metadata.annotations ||= {} of String => String)["psykube.io/whodunit"] = `whoami`.strip
      (@metadata.annotations ||= {} of String => String)["psykube.io/cause"] = ([PROGRAM_NAME] + ARGV.to_a).join(" ")
      (@metadata.annotations ||= {} of String => String)["psykube.io/last-applied-at"] = TIMESTAMP
    end

    def name
      @metadata.name
    end

    def name=(name : String)
      @metadata.name = name
    end

    ::Psykube::Kubernetes.mapping({{properties}})
  end
end
