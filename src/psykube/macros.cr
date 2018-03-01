module Psykube::Macros
  # A better way to map, with defaults
  macro mapping(properties)
    {% for key, value in properties %}
      {% properties[key] = {type: value} unless value.is_a?(HashLiteral) || value.is_a?(NamedTupleLiteral) %}
    {% end %}

    {% for key, value in properties %}
      @{{key.id}} : {{value[:type]}} {{ (value[:nilable] ? "?" : "").id }}{% if value[:default] %} = value[:default]{% end %}

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
        %var{key.id} = nil
        %found{key.id} = false
      {% end %}

      case node
      when YAML::Nodes::Mapping
        YAML::Schema::Core.each(node) do |key_node, value_node|
          unless key_node.is_a?(YAML::Nodes::Scalar)
            key_node.raise "Expected scalar as key for mapping"
          end

          key = key_node.value

          case key
          {% for key, value in properties %}
            when {{value[:key] || key.id.stringify}}
              %found{key.id} = true

              %var{key.id} =
                {% if value[:nilable] || value[:default] != nil %} YAML::Schema::Core.parse_null_or(value_node) { {% end %}

                {% if value[:type].is_a?(Path) || value[:type].is_a?(Generic) %}
                  {{value[:type]}}.new(ctx, value_node)
                {% else %}
                  ::Union({{value[:type]}}).new(ctx, value_node)
                {% end %}

                {% if value[:nilable] || value[:default] != nil %} } {% end %}
          {% end %}
          else
            key_node.raise "Unknown yaml attribute: #{key}"
          end
        end
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
        {% unless value[:nilable] || value[:default] != nil %}
          if %var{key.id}.nil? && !%found{key.id} && !::Union({{value[:type]}}).nilable?
            node.raise "Missing yaml attribute: {{(value[:key] || key).id}}"
          end
        {% end %}
      {% end %}

      {% for key, value in properties %}
        {% if value[:nilable] %}
          {% if value[:default] != nil %}
            @{{key.id}} = %found{key.id} ? %var{key.id} : {{value[:default]}}
          {% else %}
            @{{key.id}} = %var{key.id}
          {% end %}
        {% elsif value[:default] != nil %}
          @{{key.id}} = %var{key.id}.nil? ? {{value[:default]}} : %var{key.id}
        {% else %}
          @{{key.id}} = %var{key.id}.as({{value[:type]}})
        {% end %}
      {% end %}
    end

    def to_yaml(%yaml : ::YAML::Nodes::Builder)
      %yaml.mapping(reference: self) do
        {% for key, value in properties %}
          _{{key.id}} = @{{key.id}}

          unless _{{key.id}}.nil?
            # Key
            {{value[:key] || key.id.stringify}}.to_yaml(%yaml)

            # Value
            _{{key.id}}.to_yaml(%yaml)
          end
        {% end %}
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

    @version : Int32?
    @type : String?

    {% for key, value in properties %}
      {% properties[key] = {type: value} unless value.is_a?(HashLiteral) || value.is_a?(NamedTupleLiteral) %}
    {% end %}

    {% for key, value in properties %}
      @{{key.id}} : {{value[:type]}} {{ (value[:nilable] ? "?" : "").id }}{% if value[:default] %} = value[:default]{% end %}

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
      @type = nil
      {% for key, value in properties %}
        %var{key.id} = nil
        %found{key.id} = false
      {% end %}

      case node
      when YAML::Nodes::Mapping
        YAML::Schema::Core.each(node) do |key_node, value_node|
          unless key_node.is_a?(YAML::Nodes::Scalar)
            key_node.raise "Expected scalar as key for mapping"
          end

          key = key_node.value

          case key
          when "version"
            @version = Int32.new(ctx, value_node)
          when "type"
            @type = String.new(ctx, value_node)
          {% for key, value in properties %}
            when {{value[:key] || key.id.stringify}}
              %found{key.id} = true

              %var{key.id} =
                {% if value[:nilable] || value[:default] != nil %} YAML::Schema::Core.parse_null_or(value_node) { {% end %}

                {% if value[:type].is_a?(Path) || value[:type].is_a?(Generic) %}
                  {{value[:type]}}.new(ctx, value_node)
                {% else %}
                  ::Union({{value[:type]}}).new(ctx, value_node)
                {% end %}

                {% if value[:nilable] || value[:default] != nil %} } {% end %}
          {% end %}
          else
            key_node.raise "Unknown yaml attribute: #{key}"
          end
        end

        {% if type %}
          key_node.raise "invalid type: #{@type.inspect}" unless @type == {{type}}
        {% end %}

        {% if version %}
          key_node.raise "invalid version: #{@version.inspect}" unless @version == {{version}}
        {% end %}
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
        {% unless value[:nilable] || value[:default] != nil %}
          if %var{key.id}.nil? && !%found{key.id} && !::Union({{value[:type]}}).nilable?
            node.raise "Missing yaml attribute: {{(value[:key] || key).id}}"
          end
        {% end %}
      {% end %}

      {% for key, value in properties %}
        {% if value[:nilable] %}
          {% if value[:default] != nil %}
            @{{key.id}} = %found{key.id} ? %var{key.id} : {{value[:default]}}
          {% else %}
            @{{key.id}} = %var{key.id}
          {% end %}
        {% elsif value[:default] != nil %}
          @{{key.id}} = %var{key.id}.nil? ? {{value[:default]}} : %var{key.id}
        {% else %}
          @{{key.id}} = %var{key.id}.as({{value[:type]}})
        {% end %}
      {% end %}
    end

    def to_yaml(%yaml : ::YAML::Nodes::Builder)
      %yaml.mapping(reference: self) do
        {% for key, value in properties %}
          _{{key.id}} = @{{key.id}}

          unless _{{key.id}}.nil?
            # Key
            {{value[:key] || key.id.stringify}}.to_yaml(%yaml)

            # Value
            _{{key.id}}.to_yaml(%yaml)
          end
        {% end %}
      end
    end
  end
end
