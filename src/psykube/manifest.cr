module Psykube::Manifest
  alias Any = Manifest::V1 | Manifest::V2::Any

  macro mapping(*properties)
    {% all_properties = {} of String => _ %}
    {% for property_set, index in properties %}
      {% if property_set %}
        {% for key, value in property_set %}
          {% all_properties[key] = value %}
        {% end %}
      {% end %}
    {% end %}
    ::YAML.mapping({{all_properties}}, true)
  end
end

require "./manifest/*"
