class Psykube::V1::Manifest
  alias VolumeMap = Hash(String, Volume | String)
  Macros.mapping({
    name:                   {type: String},
    type:                   {type: String, default: "Deployment"},
    prefix:                 {type: String, nilable: true},
    suffix:                 {type: String, nilable: true},
    annotations:            {type: StringMap, nilable: true},
    labels:                 {type: StringMap, nilable: true},
    replicas:               {type: Int32, nilable: true},
    completions:            {type: Int32, nilable: true},
    parallelism:            {type: Int32, nilable: true},
    registry_host:          {type: String, nilable: true},
    registry_user:          {type: String, nilable: true},
    context:                {type: String, nilable: true},
    namespace:              {type: String, nilable: true},
    init_containers:        {type: Array(Pyrite::Api::Core::V1::Container), nilable: true},
    image:                  {type: String, nilable: true},
    image_tag:              {type: String, nilable: true},
    revision_history_limit: {type: Int32, nilable: true},
    resources:              {type: Resources, nilable: true},
    deploy_timeout:         {type: Int32, nilable: true, getter: false},
    restart_policy:         {type: String, nilable: true},
    max_unavailable:        {type: Int32 | String, getter: false, default: "25%"},
    max_surge:              {type: Int32 | String, getter: false, default: "25%"},
    partition:              {type: Int32, nilable: true},
    command:                {type: Array(String) | String, nilable: true},
    args:                   {type: Array(String), nilable: true},
    env:                    {type: Hash(String, Env | String), nilable: true, getter: false},
    ingress:                {type: Ingress, nilable: true},
    service:                {type: String | Service, default: "ClusterIP", nilable: true, getter: false},
    config_map:             {type: StringMap, nilable: true, getter: false},
    secrets:                {type: StringMap, nilable: true, getter: false},
    ports:                  {type: Hash(String, Int32), nilable: true, getter: false},
    clusters:               {type: Hash(String, Cluster), nilable: true, getter: false},
    healthcheck:            {type: Bool | Healthcheck, nilable: true, default: false},
    readycheck:             {type: Bool | Readycheck, nilable: true, default: false},
    volumes:                {type: VolumeMap, nilable: true},
    autoscale:              {type: Autoscale, nilable: true},
    build_args:             {type: StringMap, default: StringMap.new},
    build_context:          {type: String, nilable: true},
    dockerfile:             {type: String, nilable: true},
  })

  def initialize(@name : String, @type : String = "Deployment")
  end

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

  def get_build_contexts(cluster_name : String, basename : String, tag : String, build_context : String)
    cluster = get_cluster cluster_name
    [BuildContext.new(
      build: !image,
      image: image || basename,
      tag: cluster.image_tag || image_tag || tag,
      args: build_args.merge(cluster.build_args),
      context: @build_context || build_context,
      dockerfile: dockerfile
    )]
  end

  def get_init_build_contexts(cluster_name : String, basename : String, tag : String, build_context : String)
    [] of BuildContext
  end
end

require "./manifest/*"
