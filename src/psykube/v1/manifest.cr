class Psykube::V1::Manifest
  alias VolumeMap = Hash(String, Volume | String)
  Macros.manifest(1, nil, {
    name:                   {type: String},
    prefix:                 {type: String, optional: true},
    suffix:                 {type: String, optional: true},
    annotations:            {type: StringMap, optional: true},
    labels:                 {type: StringMap, optional: true},
    replicas:               {type: Int32, optional: true},
    completions:            {type: Int32, optional: true},
    parallelism:            {type: Int32, optional: true},
    registry_host:          {type: String, optional: true},
    registry_user:          {type: String, optional: true},
    context:                {type: String, optional: true},
    namespace:              {type: String, optional: true},
    init_containers:        {type: Array(Pyrite::Api::Core::V1::Container), optional: true},
    image:                  {type: String, optional: true},
    image_tag:              {type: String, optional: true},
    revision_history_limit: {type: Int32, optional: true},
    resources:              {type: Resources, optional: true},
    deploy_timeout:         {type: Int32, optional: true},
    restart_policy:         {type: String, optional: true},
    max_unavailable:        {type: Int32 | String, default: "25%"},
    max_surge:              {type: Int32 | String, default: "25%"},
    partition:              {type: Int32, optional: true},
    command:                {type: Array(String) | String, optional: true},
    args:                   {type: Array(String), optional: true},
    env:                    {type: Hash(String, Env | String), optional: true},
    ingress:                {type: Ingress, optional: true},
    service:                {type: String | Service, default: "ClusterIP", optional: true},
    config_map:             {type: StringMap, optional: true},
    secrets:                {type: StringMap, optional: true},
    ports:                  {type: Hash(String, Int32), optional: true},
    clusters:               {type: Hash(String, Cluster), optional: true},
    healthcheck:            {type: Bool | Healthcheck, optional: true, default: false},
    readycheck:             {type: Bool | Readycheck, optional: true, default: false},
    volumes:                {type: VolumeMap, optional: true, default: VolumeMap.new},
    autoscale:              {type: Autoscale, optional: true},
    build_args:             {type: StringMap, default: StringMap.new},
    build_context:          {type: String, optional: true},
    dockerfile:             {type: String, optional: true},
  })

  @version = 1
  @type = "Deployment"

  def initialize(@name : String, @type : String = "Deployment")
  end

  def ports?
    !ports.empty?
  end

  def service
    return unless ports?
    service = @service
    case service
    when true, nil
      Service.new "ClusterIP"
    when String
      Service.new service
    when Service
      service
    end
  end

  def deploy_timeout
    @deploy_timeout || 300
  end

  def max_unavailable
    @max_unavailable || "25%"
  end

  def max_surge
    @max_surge || "25%"
  end

  def ports
    @ports || {} of String => Int32
  end

  def config_map
    @config_map || {} of String => String
  end

  def secrets
    @secrets || {} of String => String
  end

  def env
    env = @env || {} of String => Env | String
    return env unless ports?
    env["PORT"] = lookup_port("default").to_s
    ports.each_with_object(env) do |(name, port), env|
      env["#{name.underscore.upcase.gsub("-", "_")}_PORT"] = port.to_s
    end
  end

  def lookup_port(port : Int32)
    port
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

  def service?
    !!service
  end

  def clusters
    @clusters || {} of String => Cluster
  end

  def env=(hash : StringMap)
    @env = Hash(String, Env | String).new.tap do |h|
      hash.each do |k, v|
        h[k] = hash[k]
      end
    end
  end

  def env=(hash : Hash(String, Env))
    @env = Hash(String, Env | String).new.tap do |h|
      hash.each do |k, v|
        h[k] = hash[k]
      end
    end
  end

  def generate(actor : Actor)
    Generator::List.new(self, actor).result
  end

  def get_cluster(name)
    clusters[name]? || Cluster.new
  end

  def get_build_contexts(cluster_name : String, basename : String, tag : String?, build_context : String)
    cluster = get_cluster cluster_name
    [BuildContext.new(
      build: !image,
      image: image || basename,
      tag: cluster.image_tag || image_tag || (image ? nil : tag),
      args: build_args.merge(cluster.build_args),
      context: @build_context || build_context,
      dockerfile: dockerfile
    )]
  end

  def get_init_build_contexts(cluster_name : String, basename : String, tag : String?, build_context : String)
    [] of BuildContext
  end
end

require "./manifest/*"
