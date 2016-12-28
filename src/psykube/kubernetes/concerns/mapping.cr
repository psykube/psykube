require "json"
require "yaml"

module Psykube::Kubernetes
  macro mapping(properties)
    # Manipulate properties
    {% for key, value in properties %}
      {% properties[key] = {type: value} unless value.is_a?(HashLiteral) || value.is_a?(NamedTupleLiteral) %}
    {% end %}

    {% kube_properties = {} of MacroId => _ %}

    {% for key, value in properties %}
      {% kube_properties[key.stringify.underscore] = properties[key] %}
      {% parts = key.stringify.split("_") %}
      {% camel_key = parts[0] + parts[1..-1].join("_").camelcase }
      {% kube_properties[key.stringify.underscore][:key] = properties[key][:key] || camel_key %}
    {% end %}

    {% for key, value in kube_properties %}
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
      {% for key, value in kube_properties %}
        {% unless value[:nilable] || value[:type].stringify =~ /\|/ %}
          {% if value[:default] %}
            @{{key.id}} = {{ value[:default] }}
          {% else %}
            @{{key.id}} = {{ value[:type] }}.new
          {% end %}
        {% end %}
      {% end %}
    end

    ::YAML.mapping({{kube_properties}}, true)
    ::JSON.mapping({{kube_properties}}, true)
  end

  macro mapping(**properties)
    Psykube::Kubernetes.mapping({{properties}})
  end
end
