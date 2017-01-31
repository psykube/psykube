require "json"
require "yaml"

module Psykube::Kubernetes

  macro mapping(properties)

    # Manipulate properties
    {% for key, value in properties %}
      {% properties[key] = {type: value} unless value.is_a?(HashLiteral) || value.is_a?(NamedTupleLiteral) %}
    {% end %}

    {% obj_properties = {} of MacroId => _ %}
    {% settings = {} of MacroId => _ %}

    {% for key, value in properties %}
      {% prop_key = key.stringify.underscore %}
      {% obj_properties[prop_key] = {} of MacroId => _ %}
      {% settings[prop_key] = {} of MacroId => _ %}

      # Copy the valid properties
      {% obj_properties[prop_key][:type] = properties[key][:type] %}
      {% obj_properties[prop_key][:nilable] = properties[key][:nilable] %}
      {% obj_properties[prop_key][:getter] = properties[key][:getter] %}
      {% obj_properties[prop_key][:setter] = properties[key][:setter] %}
      {% obj_properties[prop_key][:default] = properties[key][:default] %}
      {% settings[prop_key][:clean] = properties[key][:clean] %}
      {% settings[prop_key][:type] = properties[key][:type] %}

      # set the proper key
      {% if properties[key][:key] %}
        {% obj_properties[prop_key][:key] = properties[key][:key] %}
      {% else %}
        {% key_parts = prop_key.split("_") %}
        {% camel_key = key_parts[0] + key_parts[1..-1].join("_").camelcase }
        {% obj_properties[prop_key][:key] = camel_key %}
      {% end %}
    {% end %}

    # Initialize all default attributes
    def initialize
      {% for key, value in obj_properties %}
        # {{ value[:type].stringify }}
        {% unless value[:nilable] || value[:type].stringify =~ /\|/ || value[:type].stringify =~ /^::Union/ %}
          {% if value[:default] %}
            @{{key.id}} = {{ value[:default] }}
          {% else %}
            @{{key.id}} = {{ value[:type] }}.new
          {% end %}
        {% end %}
      {% end %}
    end

    module Cleaner
      def clean!
        {% for key, value in settings %}
          {% if value[:clean] %}
            @{{key.id}} = nil
          {% end %}
          cleanable = @{{key.id}}
          if cleanable.responds_to?(:clean!)
            cleanable.clean!
          elsif cleanable.responds_to?(:each)
            cleanable.each do |v|
              v.clean! if v.responds_to? :clean!
            end
          end
        {% end %}
        self
      end
    end

    include Cleaner

    ::YAML.mapping({{obj_properties}})
    ::JSON.mapping({{obj_properties}})
  end

  macro mapping(**properties)
    ::Psykube::Kubernetes.mapping({{properties}})
  end
end
