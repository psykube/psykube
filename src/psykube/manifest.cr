require "yaml"
require "./name_cleaner"

class Psykube::Manifest
  macro mapping(properties)
    ::YAML.mapping({{properties}}, true)
  end

  alias VolumeMap = Hash(String, Volume | String)
  mapping({
    name:                   {type: String, getter: false},
    type:                   {type: String, default: "Deployment"},
    annotations:            Hash(String, String)?,
    labels:                 Hash(String, String)?,
    replicas:               UInt32?,
    completions:            UInt32?,
    parallelism:            UInt32?,
    registry_host:          String?,
    registry_user:          String?,
    context:                String?,
    namespace:              String?,
    image:                  String?,
    revision_history_limit: UInt32?,
    deploy_timeout:         {type: UInt32, nilable: true, getter: false},
    restart_policy:         String?,
    max_unavailable:        {type: UInt32, nilable: true, getter: false},
    max_surge:              {type: UInt32, nilable: true, getter: false},
    command:                Array(String) | String | Nil,
    args:                   Array(String)?,
    env:                    {type: Hash(String, Env | String), nilable: true, getter: false},
    ingress:                Ingress?,
    service:                {type: String | Service, default: "ClusterIP", nilable: true, getter: false},
    config_map:             {type: Hash(String, String), nilable: true, getter: false},
    secrets:                {type: Hash(String, String), nilable: true, getter: false},
    ports:                  {type: Hash(String, UInt16), nilable: true, getter: false},
    clusters:               {type: Hash(String, Cluster), nilable: true, getter: false},
    healthcheck:            {type: Bool | Healthcheck, nilable: true, default: false, getter: false},
    readycheck:             {type: Bool | Readycheck, nilable: true, default: false, getter: false},
    volumes:                {type: VolumeMap, nilable: true},
    autoscale:              {type: Autoscale, nilable: true},
    build_args:             {type: Hash(String, String), nilable: true, getter: false},
  })

  def initialize(@name : String, @type : String = "Deployment")
  end

  def healthcheck
    @healthcheck || false
  end

  def readycheck
    @readycheck || false
  end

  def service
    return unless service?
    @service = case (service = @service)
               when "true"
                 Service.new "ClusterIP"
               when String
                 Service.new service
               when Service
                 service
               end
  end

  def deploy_timeout
    @deploy_timeout || 300_u32
  end

  def build_args
    @build_args || {} of String => String
  end

  def max_unavailable
    @max_unavailable || 0_u32
  end

  def max_surge
    @max_surge || 1_u32
  end

  def ports
    @ports || {} of String => UInt16
  end

  def config_map
    @config_map || {} of String => String
  end

  def secrets
    @secrets || {} of String => String
  end

  def env
    @env || {} of String => Env | String
  end

  def name
    NameCleaner.clean(@name)
  end

  def service?
    return unless @service
    !!@ports.try(&.first?)
  end

  def clusters
    @clusters || {} of String => Cluster
  end

  def env=(hash : Hash(String, String))
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
end

require "./manifest/*"
