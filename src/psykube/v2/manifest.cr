abstract class Psykube::V2::Manifest
  module Serviceable; end

  DECLARED = [] of Manifest.class

  def Psykube::V2::Manifest.new(ctx : YAML::ParseContext, node : YAML::Nodes::Node)
    if node.is_a?(YAML::Nodes::Alias)
      DECLARED.each do |type|
        ctx.read_alias?(node, type) do |obj|
          return obj
        end
      end

      node.raise("Error deserailizing alias")
    end

    DECLARED.each do |type|
      begin
        return type.new(ctx, node)
      rescue YAML::ParseException
        # Ignore
      end
    end

    node.raise "Couldn't parse #{self}"
  end

  macro declare(type, properties = nil, *, service = true, default = false)
    DECLARED << self

    def generate(actor : Actor)
      Generator::List.new(self, actor).result
    end

    def get_build_contexts(cluster_name : String, basename : String, tag : String?, build_context : String)
      cluster = get_cluster cluster_name
      containers.map do |container_name, container|
        BuildContext.new(
          build: !container.image,
          image: container.image || [basename, container_name].join('.'),
          tag: container.image ? nil : (container.tag || tag),
          args: container.build_args.merge(cluster.container_overrides.build_args),
          context: container.build_context || build_context,
          dockerfile: cluster.container_overrides.dockerfile
        )
      end
    end

    def get_init_build_contexts(cluster_name : String, basename : String, tag : String?, build_context : String)
      cluster = get_cluster cluster_name
      init_containers.map do |container_name, container|
        BuildContext.new(
          build: !container.image,
          image: container.image || [basename, container_name].join('.'),
          tag: container.image ? nil : (container.tag || tag),
          args: container.build_args.merge(cluster.container_overrides.build_args),
          context: container.build_context || build_context,
          dockerfile: cluster.container_overrides.dockerfile
        )
      end
    end

    def get_cluster(name)
      clusters[name]? || Shared::Cluster.new
    end

    def volumes
      containers.each_with_object(VolumeMap.new) do |(container_name, container), volume_map|
        container.volumes.each do |volume_name, volume|
          volume_map["#{container_name}.#{volume_name}"] = volume
        end
      end
    end

    Macros.manifest(2, {{type}}, {{properties}}, {
      name:                            {type: String},
      automount_service_account_token: {type: Bool, optional: true},
      prefix:                          {type: String, optional: true, envvar: "PSYKUBE_PREFIX"},
      suffix:                          {type: String, optional: true, envvar: "PSYKUBE_SUFFIX"},
      registry_host:                   {type: String, optional: true, envvar: "PSYKUBE_REGISTRY_HOST"},
      registry_user:                   {type: String, optional: true, envvar: "PSYKUBE_REGISTRY_USER"},
      context:                         {type: String, optional: true, envvar: "PSYKUBE_CONTEXT"},
      namespace:                       {type: String, optional: true, envvar: "PSYKUBE_NAMESPACE"},
      restart_policy:                  {type: String, optional: true},
      annotations:                     {type: StringMap, default: StringMap.new},
      labels:                          {type: StringMap, default: StringMap.new},
      config_map:                      {type: StringMap, default: StringMap.new},
      secrets:                         {type: StringMap, default: StringMap.new},
      affinity:                        {type: Pyrite::Api::Core::V1::Affinity, optional: true},
      init_containers:                 {type: ContainerMap, default: ContainerMap.new},
      containers:                      {type: ContainerMap},
      clusters:                        {type: ClusterMap, default: ClusterMap.new },
      {% if service %}
        ingress: {type: V1::Manifest::Ingress, optional: true},
        services: {type: Array(String) | Hash(String, String | V1::Manifest::Service), default: "ClusterIP", optional: true }
      {% end %}
    })

    {% if service %}
      include Serviceable

      def ports?
        !ports.empty?
      end

      def services?
        services.size > 0
      end

      def lookup_port(port : Int32)
        port
      end

      def ports
        containers.each_with_object(PortMap.new) do |(container_name, container), port_map|
          container.ports.each do |port_name, port|
            port_map[port_name] ||= port
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
  end
end

require "./manifest/shared/*"
require "./manifest/*"
