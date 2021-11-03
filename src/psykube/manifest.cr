require "random"

abstract class Psykube::Manifest
  class PortError < Psykube::Error; end

  module Serviceable; end

  module Jobable; end

  DECLARED = [] of Manifest.class

  def Psykube::Manifest.new(ctx : YAML::ParseContext, node : YAML::Nodes::Node)
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

    def podable(actor : Actor) : Psykube::Generator::Podable::Resource
      Generator::Podable.new(self, actor).result
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
        container_name: container_name,
        build: build,
        image: image,
        tag: container.tag || tag,
        args: (container.build.try(&.args) || StringableMap.new).merge(cluster.container_overrides.build_args),
        context: get_context_path(container, working_directory),
        dockerfile: container.build.try(&.dockerfile) || cluster.container_overrides.dockerfile,
        login: get_login(image, image_pull_secrets),
        cache_from: container.build.try(&.cache_from),
        build_tags: container.build.try(&.tag),
        stages: container.build.try(&.stages) || [] of String,
        target: container.build.try(&.target),
        platform: container.build.try(&.platform) || "linux/amd64"
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

    Macros.manifest({{type}}, {{properties}}, {
      name:                            {type: String},
      automount_service_account_token: {type: Bool, optional: true},
      service_account:                 {type: Bool | String | Shared::ServiceAccount, optional: true},
      roles:                           {type: Array(String | Shared::Role | Shared::ClusterRoleType), optional: true},
      cluster_roles:                   {type: Array(String | Shared::Role), optional: true},
      image_pull_secrets:              {type: Array(String | Shared::PullSecretCredentials), optional: true},
      prefix:                          {type: String, optional: true, envvar: "PSYKUBE_PREFIX"},
      suffix:                          {type: String, optional: true, envvar: "PSYKUBE_SUFFIX"},
      registry_host:                   {type: String, optional: true, envvar: "PSYKUBE_REGISTRY_HOST"},
      registry_user:                   {type: String, optional: true, envvar: "PSYKUBE_REGISTRY_USER"},
      context:                         {type: String, optional: true, envvar: "PSYKUBE_CONTEXT"},
      namespace:                       {type: String, optional: true, envvar: "PSYKUBE_NAMESPACE"},
      restart_policy:                  {type: String, optional: true},
      node_selector:                   {type: StringableMap, optional: true},
      pod_annotations:                 {type: StringableMap, default: StringableMap.new},
      annotations:                     {type: StringableMap, default: StringableMap.new},
      labels:                          {type: StringableMap, default: StringableMap.new},
      config_map:                      {type: StringableMap, default: StringableMap.new},
      secrets:                         {type: StringableMap | Bool, optional: true},
      affinity:                        {type: Pyrite::Api::Core::V1::Affinity, optional: true},
      init_containers:                 {type: ContainerMap, default: ContainerMap.new},
      containers:                      {type: ContainerMap},
      host_pid:                        {type: Bool, optional: true},
      host_network:                    {type: Bool, optional: true},
      dns_policy:                      {type: String, optional: true},
      termination_grace_period:        {type: Int32, optional: true},
      tolerations:                     {type: Array(Pyrite::Api::Core::V1::Toleration), optional: true},
      clusters:                        {type: ClusterMap, default: ClusterMap.new },
      volumes:                         {type: VolumeMap, default: VolumeMap.new},
      security_context:                {type: Pyrite::Api::Core::V1::PodSecurityContext, optional: true},
      enable_service_links:            {type: Bool, optional: true},
      commands:                        {type: Hash(String, String), optional: true},
      {% if service %}
        ingress:                       {type: Manifest::Ingress, optional: true},
        services:                      {type: Array(String) | Hash(String, String | Manifest::Service), default: "ClusterIP", optional: true },
      {% end %}
      {% if jobable %}
        jobs:                          {type: Hash(String, Shared::InlineJob | String | Array(String)), optional: true},
        cron_jobs:                     {type: Hash(String, Shared::InlineCronJob), optional: true},
      {% end %}
    })

    def ports
      containers.each_with_object(PortMap.new) do |(container_name, container), port_map|
        container.ports.each do |port_name, port|
          port_map[port_name] ||= port
        end
      end
    end

    def lookup_port!(port_name : Nil = nil)
      ports["default"]? || ports.values.first? || raise Psykube::Error.new "Containers do not export any ports"
    end

    def lookup_port!(port_number : Int32)
      raise Psykube::Error.new "No container exports port #{port_number}" unless ports.values.includes? port_number
      port_number
    end

    def lookup_port!(port_name : String)
      if (port_int = port_name.to_i?)
        lookup_port! port_int
      else
        ports[port_name]? || raise Psykube::Error.new "No port named #{port_name}"
      end
    end

    def lookup_port(port : Int32 | String | Nil = nil)
      lookup_port!(port)
    rescue PortError
      nil
    end

    {% if service %}
      include Serviceable

      def ports?
        !ports.empty?
      end

      def services?
        services.size > 0
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
