module Psykube::Macros
  # :nodoc:
  macro __mapping(properties)
    {% for key, value in properties %}
      @{{key.id}} : {{value[:type]}} {{ (value[:optional] || value[:default] ? "?" : "").id }}

      def {{key.id}}=(_{{key.id}} : {{value[:type]}} {{ (value[:optional] ? "?" : "").id }})
        @{{key.id}} = _{{key.id}}
      end

      def {{key.id}}
        @{{key.id}}{% if value[:default] %} || {{ value[:default] }}{% end %}
      end
    {% end %}

    def initialize(*,
      {% for key, value in properties %}
        @{{key.id}}{% if value[:default] || value[:optional] %} = {{ value[:optional] ? "nil".id : value[:default] }}{% end %},
      {% end %}
    ) ; end

    def self.new(ctx : YAML::ParseContext, node : YAML::Nodes::Node)
      ctx.read_alias(node, \{{@type}}) do |obj|
        return obj
      end

      instance = allocate

      ctx.record_anchor(node, instance)

      instance.initialize(ctx, node, nil)
      instance
    end

    def initialize(ctx : YAML::ParseContext, node : ::YAML::Nodes::Node, _dummy : Nil)
      {% for key, value in properties %}
        {% if value[:envvar] %}
          __{{key.id}}__value = ENV[{{ value[:envvar] }}]?
          __{{key.id}}__found = !!ENV[{{ value[:envvar] }}]?
        {% else %}
          __{{key.id}}__value = nil
          __{{key.id}}__found = false
        {% end %}
      {% end %}

      case node
      when YAML::Nodes::Mapping
        {{yield}}
      when YAML::Nodes::Scalar
        if node.value.empty? && node.style.plain? && !node.tag
          # We consider an empty scalar as an empty mapping
        else
          node.raise "Expected mapping, not #{node.class}"
        end
      else
        node.raise "Expected mapping, not #{node.class}"
      end

      {% for key, value in properties %}
        {% unless value[:optional] || value[:default] != nil %}
          if __{{key.id}}__value.nil? && !__{{key.id}}__found && !::Union({{value[:type]}}).nilable?
            node.raise "Missing yaml attribute: {{(value[:key] || key).id}}"
          end
        {% end %}
      {% end %}

      {% for key, value in properties %}
        {% if value[:optional] %}
          @{{key.id}} = __{{key.id}}__value
        {% elsif value[:default] != nil %}
          @{{key.id}} = __{{key.id}}__value.nil? ? {{value[:default]}} : __{{key.id}}__value
        {% else %}
          @{{key.id}} = __{{key.id}}__value.as({{value[:type]}})
        {% end %}
      {% end %}
    end

    def to_yaml(yaml : ::YAML::Nodes::Builder)
      yaml.mapping(reference: self) do
        {% for key, value in properties %}
          _{{key.id}} = @{{key.id}}

          unless _{{key.id}}.nil? || (_{{key.id}}.is_a?(Enumerable) && _{{key.id}}.empty?)
            # Key
            {{value[:key] || key.id.stringify}}.to_yaml(yaml)

            # Value
            _{{key.id}}.to_yaml(yaml)
          end
        {% end %}
      end
    end
  end

  # :nodoc:
  macro __check_scalar(key_node)
    unless {{key_node}}.is_a?(YAML::Nodes::Scalar)
      {{key_node}}.raise "Expected scalar as key for mapping"
    end
  end

  # :nodoc:
  macro __case_keys(key_node, value_node, properties)
    key = {{key_node}}.value

    case key
    {% for key, value in properties %}
      when {{value[:key] || key.id.stringify}}
        unless __{{key.id}}__found && {{ !!value[:envvar] }}
          __{{key.id}}__found = true

          __{{key.id}}__value =
            {% if value[:optional] || value[:default] != nil %} YAML::Schema::Core.parse_null_or({{value_node}}) { {% end %}

            {% if value[:type].is_a?(Path) || value[:type].is_a?(Generic) %}
              {{value[:type]}}.new(ctx, {{value_node}})
            {% else %}
              ::Union({{value[:type]}}).new(ctx, {{value_node}})
            {% end %}

            {% if value[:optional] || value[:default] != nil %} } {% end %}
        end
    {% end %}
    else
      key_node.raise "Unknown yaml attribute: #{key}"
    end
  end

  # A mapping for a sub manifest
  macro mapping(properties)
    ::Psykube::Macros.__mapping({{properties}}) do
      YAML::Schema::Core.each(node) do |key_node, value_node|
        ::Psykube::Macros.__check_scalar(key_node)
        ::Psykube::Macros.__case_keys(key_node, value_node, {{properties}})
      end
    end
  end

  # The macro to create a manifest root
  macro manifest(version, type, *property_sets)
    {% properties = {} of String => _ %}
    {% for property_set, index in property_sets %}
      {% if property_set %}
        {% for key, value in property_set %}
          {% properties[key] = value %}
        {% end %}
      {% end %}
    {% end %}

    getter version : Int32? = nil
    getter type : String? = nil

    {% raise "version key not allowed" if properties[:version] %}
    {% raise "type key not allowed" if properties[:type] %}

    ::Psykube::Macros.__mapping({{properties}}) do
      version_location = {0,0}
      type_location = {0,0}

      YAML::Schema::Core.each(node) do |key_node, value_node|
        ::Psykube::Macros.__check_scalar(key_node)

        case key_node.value
        when "version"
          version_location = key_node.location
          @version = Int32.new(ctx, value_node)
          next
        when "type"
          type_location = key_node.location
          @type = String.new(ctx, value_node)
          next
        end

        ::Psykube::Macros.__case_keys(key_node, value_node, {{properties}})
      end

      {% if version %}
        {% if version %}raise YAML::ParseException.new("invalid version: #{@version.inspect}", *version_location) unless @version == {{version}}{% end %}
      {% end %}

      {% if type %}
        {% if type %}raise YAML::ParseException.new("invalid type: #{@type.inspect}", *type_location) unless @type == {{type}}{% end %}
      {% end %}
    end

    def initialize(*,
      {% for key, value in properties %}
        @{{key.id}}{% if value[:default] || value[:optional] %} = {{ value[:optional] ? "nil".id : value[:default] }}{% end %},
      {% end %}
    )
      @version = {{version}}
      @type = {{type}}
    end

    def to_yaml(yaml : ::YAML::Nodes::Builder)
      yaml.mapping(reference: self) do
        version = @version
        type = @type

        # Set version
        unless version.nil?
          "version".to_yaml(yaml)
          version.to_yaml(yaml)
        end

        # Set type
        unless type.nil?
          "type".to_yaml(yaml)
          type.to_yaml(yaml)
        end

        {% for key, value in properties %}
          _{{key.id}} = @{{key.id}}

          unless _{{key.id}}.nil? || (_{{key.id}}.is_a?(Enumerable) && _{{key.id}}.empty?)
            # Key
            {{value[:key] || key.id.stringify}}.to_yaml(yaml)

            # Value
            _{{key.id}}.to_yaml(yaml)
          end
        {% end %}
      end
    end
  end
end
