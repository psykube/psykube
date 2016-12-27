require "json"
require "yaml"

module Psykube::Kubernetes
  macro mapping(properties)
    # Manipulate properties
    {% for key, value in properties %}
      {% properties[key] = {type: value} unless value.is_a?(HashLiteral) || value.is_a?(NamedTupleLiteral) %}
    {% end %}

    {% for key, value in properties %}
      @{{key.id}} : {{value[:type]}} {{ (value[:nilable] ? "?" : "").id }}

      {% if value[:setter] == nil ? true : value[:setter] %}
        def {{key.id}}=(_{{key.id}} : {{value[:type]}} {{ (value[:nilable] ? "?" : "").id }})
          @{{key.id}} = _{{key.id}}
        end
      {% end %}

      {% if value[:getter] == nil ? true : value[:getter] %}
        def {{key.id}}
          @{{key.id}}
        end
      {% end %}
    {% end %}

    def initialize
      {% for key, value in properties %}
        {% unless value[:nilable] || value[:type].stringify =~ /\|/ %}
          {% if value[:default] %}
            @{{key.id}} = {{ value[:default] }}
          {% else %}
            @{{key.id}} = {{ value[:type] }}.new
          {% end %}
        {% end %}
      {% end %}
    end

    ::YAML.mapping({{properties}}, true)
    ::JSON.mapping({{properties}}, true)
  end

  macro mapping(**properties)
    Psykube::Kubernetes.mapping({{properties}})
  end
end
