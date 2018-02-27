require "./v2/shared/*"

module Psykube::Manifest::V2
  struct VersionCheck
    def initialize
    end

    def initialize(ctx : YAML::ParseContext, node : YAML::Nodes::Node)
      node.raise "Invalid version, expected `version: 2`" unless Int32.new(ctx, node) == 2
    end
  end

  alias Any = V2::Deployment | V2::Job | V2::StatefulSet | V2::CronJob | V2::Pod | V2::DaemonSet
  alias ClusterMap = Hash(String, Shared::Cluster)
  alias ContainerMap = Hash(String, Shared::Container)

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

    def volumes
      containers.each_with_object(VolumeMap.new) do |(container_name, container), volume_map|
        container.volumes.each do |volume_name, volume|
          volume_map["#{container_name}.#{volume_name}"] = volume
        end
      end
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
        containers.each_with_object(PortMap.new) do |(container_name, container), port_map|
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
    {% end %}

    Manifest.mapping({{properties}}, {
      type:                            TypeCheck{% if default %}?{% end %},
      name:                            {type: String, getter: false},
      version:                         {type: V2::VersionCheck},
      automount_service_account_token: {type: Bool, nilable: true},
      prefix:                          {type: String, nilable: true},
      suffix:                          {type: String, nilable: true},
      registry_host:                   {type: String, nilable: true},
      registry_user:                   {type: String, nilable: true},
      default_context:                 {type: String, nilable: true},
      default_namespace:               {type: String, nilable: true},
      restart_policy:                  {type: String, nilable: true},
      annotations:                     {type: StringMap, default: StringMap.new},
      labels:                          {type: StringMap, default: StringMap.new},
      config_map:                      {type: StringMap, default: StringMap.new},
      secrets:                         {type: StringMap, default: StringMap.new},
      affinity:                        {type: Pyrite::Api::Core::V1::Affinity, nilable: true},
      init_containers:                 {type: ContainerMap, default: ContainerMap.new},
      containers:                      {type: ContainerMap},
      clusters:                        {type: ClusterMap, default: ClusterMap.new },
      {% if service %}
        ingress: {type: V1::Ingress, nilable: true},
        service: {type: String | V1::Service, default: "ClusterIP", nilable: true, getter: false}
      {% end %}
    })

    @type = TypeCheck.new
    @name = ""
    @version = V2::VersionCheck.new
    @containers = ContainerMap.new
    @init_containers = ContainerMap.new
    @secrets = StringMap.new
    @config_map = StringMap.new
    @clusters = ClusterMap.new
    @annotations = StringMap.new
    @labels = StringMap.new
  end
end

require "./v2/*"
