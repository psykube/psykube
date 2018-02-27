module Psykube::Manifest::V2
  struct VersionCheck
    def initialize
    end

    def initialize(ctx : YAML::ParseContext, node : YAML::Nodes::Node)
      node.raise "Invalid version, expected `version: 2`" unless Int32.new(ctx, node) == 2
    end
  end

  alias Any = V2::Deployment | V2::Job | V2::StatefulSet | V2::CronJob | V2::Pod | V2::DaemonSet

  macro declare_manifest(type, properties = nil, *, service = true, default = false)
    struct TypeCheck
      def initialize
      end

      def initialize(ctx : YAML::ParseContext, node : YAML::Nodes::Node)
        node.raise "Invalid type, expected `type: {{type.id}}`" unless String.new(ctx, node) == {{type}}
      end
    end

    def initialize(@name : String, @type : String = "Deployment")
    end

    def name
      NameCleaner.clean(@name)
    end

    {% if service %}
      def ports?
        !ports.empty?
      end

      def service
        return unless ports?
        service = @service
        @service = case service
                   when "true", true
                     Service.new "ClusterIP"
                   when String
                     Service.new service
                   when Service
                     service
                   end
      end

      def service?
        !!service
      end

      def lookup_port(port : Int32)
        port
      end

      def ports
        containers.each_with_object({} of String => Int32) do |(container_name, container), port_map|
          container.ports.each do |port_name, port|
            port_map[port_name] ||= port
            port_map["#{container_name}.#{port_name}"] = port
          end
        end
      end

      def lookup_port(port_name : String)
        if port_name.to_i?
          port_name.to_i
        elsif port_name == "default" && !ports.key?("default")
          ports.values.first
        else
          ports[port_name]? || raise "Invalid port #{port_name}"
        end
      end

      Manifest.mapping({{properties}}, {
        type: TypeCheck{% if default %}?{% end %},
        version:                         Psykube::Manifest::V2::VersionCheck,
        automount_service_account_token: {type: Bool, nilable: true},
        affinity:                        {type: Pyrite::Api::Core::V1::Affinity, nilable: true},
        name:                            {type: String, getter: false},
        prefix:                          {type: String, nilable: true},
        suffix:                          {type: String, nilable: true},
        annotations:                     {type: Hash(String, String)?, nilable: true},
        labels:                          {type: Hash(String, String)?, nilable: true},
        registry_host:                   {type: String, nilable: true},
        registry_user:                   {type: String, nilable: true},
        default_context:                 {type: String, nilable: true},
        default_namespace:               {type: String, nilable: true},
        restart_policy:                  {type: String, nilable: true},
        config_map:                      {type: Hash(String, String)},
        secrets:                         {type: Hash(String, String)},
        init_containers:                 {type: Hash(String, Shared::Container)},
        containers:                      {type: Hash(String, Shared::Container)},
        clusters:                        {type: Hash(String, V1::Cluster)},
        ingress: {type: V1::Ingress, nilable: true},
        service: {type: String | V1::Service, default: "ClusterIP", nilable: true, getter: false}
      })
    {% else %}
      Manifest.mapping({{properties}}, {
        type: TypeCheck{% if default %}?{% end %},
        version:                         Psykube::Manifest::V2::VersionCheck,
        automount_service_account_token: {type: Bool, nilable: true},
        affinity:                        {type: Pyrite::Api::Core::V1::Affinity, nilable: true},
        name:                            {type: String, getter: false},
        prefix:                          {type: String, nilable: true},
        suffix:                          {type: String, nilable: true},
        annotations:                     {type: Hash(String, String), default: {} of String => String},
        labels:                          {type: Hash(String, String), default: {} of String => String},
        registry_host:                   {type: String, nilable: true},
        registry_user:                   {type: String, nilable: true},
        default_context:                 {type: String, nilable: true},
        default_namespace:               {type: String, nilable: true},
        restart_policy:                  {type: String, nilable: true},
        config_map:                      {type: Hash(String, String), default: {} of String => String},
        secrets:                         {type: Hash(String, String), default: {} of String => String},
        init_containers:                 {type: Hash(String, Shared::Container), default: {} of String => Shared::Container},
        containers:                      {type: Hash(String, Shared::Container)},
        clusters:                        {type: Hash(String, V1::Cluster), default: {} of String => V1::Cluster },
      })
    {% end %}

    @version = Psykube::Manifest::V2::VersionCheck.new
    @type = TypeCheck.new
    @name = ""
    @containers = {} of String => Shared::Container
    @init_containers = {} of String => Shared::Container
    @secrets = {} of String => String
    @config_map = {} of String => String
    @clusters = {} of String => V1::Cluster
    @annotations = {} of String => String
    @labels = {} of String => String
  end
end

require "./v2/*"
require "./v2/shared/*"
