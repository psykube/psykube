require "./manifest/shared/*"

abstract class Psykube::V2::Manifest
  alias ClusterMap = Hash(String, Shared::Cluster)
  alias ContainerMap = Hash(String, Shared::Container)

  macro declare(type, properties = nil, *, service = true, default = false)
    def generate(actor : Actor)
      Generator::List.new(self, actor).result
    end

    def get_build_contexts(cluster_name : String, basename : String, tag : String, build_context : String)
      cluster = get_cluster cluster_name
      containers.map do |container_name, container|
        BuildContext.new(
          build: !container.image,
          image: container.image || [basename, container_name].join('.'),
          tag: container.tag || tag,
          args: container.build_args.merge(cluster.container_overrides.build_args),
          context: container.build_context || build_context,
          dockerfile: cluster.container_overrides.dockerfile || dockerfile
        )
      end
    end

    def get_cluster(name)
      clusters[name]? || Cluster.new
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

    Macros.manifest(2, {{type}}, {{properties}}, {
      name:                            {type: String, getter: false},
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
  end
end

require "./manifest/*"
