module Psykube::Manifest
  alias StringMap = Hash(String, String)
  alias PortMap = Hash(String, Int32)
  alias VolumeMap = Hash(String, V1::Volume | String)
  alias Any = V1 | V2::Any

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
