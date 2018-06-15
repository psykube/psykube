abstract class Psykube::V2::Manifest
  module Serviceable; end
  module Jobable; end

  alias Readycheck = V1::Manifest::Readycheck
  alias Healthcheck = V1::Manifest::Healthcheck
  alias Env = V1::Manifest::Env
  alias Ingress = V1::Manifest::Ingress
  alias Service = V1::Manifest::Service
  alias Autoscale = V1::Manifest::Autoscale
  alias Resources = V1::Manifest::Resources

  DECLARED = [] of Manifest.class

  def Psykube::V2::Manifest.new(ctx : YAML::ParseContext, node : YAML::Nodes::Node)
    if node.is_a?(YAML::Nodes::Alias)
      DECLARED.each do |type|
        ctx.read_alias?(node, type) do |obj|
          return obj
        end
      end

      raise ParseException.new raise("Error deserailizing alias"), *node.location
    end

    DECLARED.each do |type|
      begin
        return type.new(ctx, node)
      rescue TypeException
        # Ignore
      end
    end

    raise ParseException.new "Couldn't parse #{self}", *node.location
  end

  macro declare(type, properties = nil, *, service = true, default = false, jobable = false)
    DECLARED << self

    def generate(actor : Actor)
      Generator::List.new(self, actor).result
    end

    def get_build_contexts(cluster_name : String, basename : String, tag : String?, working_directory : String)
      containers.map do |container_name, container|
        get_build_context(container_name, container, cluster_name, basename, tag, working_directory)
      end
    end

    def get_init_build_contexts(cluster_name : String, basename : String, tag : String?, working_directory : String)
      init_containers.map do |container_name, container|
        if container.is_a? Shared::Container
          get_build_context(container_name, container, cluster_name, basename, tag, working_directory)
        else
          get_build_contexts(cluster_name, basename, tag, working_directory)[0]
        end
      end
    end

    def unique_contexts
      (init_containers.values + containers.values).map do |container|
        container.build if container.is_a? Shared::Container
      end.compact.uniq
    end

    def get_container_image(container_name : String, container : Shared::Container, basename : String) : String
      if (image = container.image)
        image
      elsif unique_contexts.size > 1
        [basename, container_name].compact.join('-')
      else
        basename
      end
    end

    def get_context_path(container : Shared::Container, working_directory : String)
      File.expand_path(container.build.try(&.context) || ".", working_directory)
    end

    def get_build_context(container_name : String, container : Shared::Container, cluster_name : String, basename : String, tag : String?, working_directory : String)
      image = get_container_image(container_name, container, basename)
      build = container.image.nil? || !container.build.nil?
      cluster = get_cluster cluster_name
      BuildContext.new(
        build: build,
        image: image,
        tag: container.image ? nil : (container.tag || tag),
        args: (container.build.try(&.args) || StringMap.new).merge(cluster.container_overrides.build_args),
        context: get_context_path(container, working_directory),
        dockerfile: container.build.try(&.dockerfile) || cluster.container_overrides.dockerfile,
        login: get_login(image, image_pull_secrets)
      )
    end

    def get_build_context(container_name : String, container : String | Array(String), cluster_name : String, basename : String, tag : String?, working_directory : String)
    end

    def get_login(image : String, _nil : Nil)
    end

    def get_login(image : String, creds : Array(String | Shared::PullSecretCredentials))
      cred = creds.find do |cred|
        case cred
        when Shared::PullSecretCredentials
          parts = image.split('/')
          parts.size < 3 || cred.server == parts[0]
        end
      end

      if cred.is_a? Shared::PullSecretCredentials
        BuildContext::Login.new(
          server: cred.server,
          username: cred.username,
          password: cred.password
        )
      end
    end

    def get_cluster(name)
      clusters[name]? || Shared::Cluster.new
    end

    Macros.manifest(2, {{type}}, {{properties}}, {
      name:                            {type: String},
      automount_service_account_token: {type: Bool, optional: true},
      service_account:                 {type: String | Shared::ServiceAccount, optional: true},
      roles:                           {type: Array(String | Shared::Role), optional: true},
      cluster_roles:                   {type: Array(String | Shared::Role), optional: true},
      image_pull_secrets:              {type: Array(String | Shared::PullSecretCredentials), optional: true},
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
      init_containers:                 {type: ContainerMap | Hash(String, Array(String) | String), default: ContainerMap.new},
      containers:                      {type: ContainerMap},
      clusters:                        {type: ClusterMap, default: ClusterMap.new },
      volumes:                         {type: VolumeMap, optional: true},
      security_context: {type: Shared::SecurityContext, optional: true},
      {% if service %}
        ingress: {type: Manifest::Ingress, optional: true},
        services: {type: Array(String) | Hash(String, String | Manifest::Service), default: "ClusterIP", optional: true },
      {% end %}
      {% if jobable %}
        jobs:          {type: Hash(String, Shared::InlineJob | String | Array(String)), optional: true},
        cron_jobs:     {type: Hash(String, Shared::InlineCronJob), optional: true}
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
        elsif port_name == "default" && !ports.has_key?("default")
          ports.values.first
        else
          ports[port_name]? || raise "Invalid port #{port_name}"
        end
      end
    {% end %}

    {% if jobable %}
      include Jobable
      def get_job(actor, name)
        Generator::InlineJob.new(self, actor).result(name)
      end
    {% else %}
      def get_job(actor, name)
        raise Error.new("Jobs are not supported for this manifest type")
      end
    {% end %}
  end
end

require "./manifest/shared/*"
require "./manifest/*"
