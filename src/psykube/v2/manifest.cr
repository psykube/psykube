abstract class Psykube::V2::Manifest
  class TypeMatcher
    YAML.mapping({type: String?})
  end

  DECLARED = [] of Manifest.class

  def self.new(ctx : YAML::ParseContext, node : YAML::Nodes::Node)
    specified_type = TypeMatcher.new(ctx, node).type
    manifest_type = DECLARED.find(&.manifest_type.== specified_type)
    node.raise "Invalid manifest type: #{specified_type}" unless manifest_type
    manifest_type.new(ctx, node)
  end

  macro declare(type, properties = nil, *, service = true, default = false, jobs = true)
    include Declaration
    {% if jobs %}
      alias CronJobMap =  Hash(String, Shared::InlineCronJob | Shared::InlineCronJobRef)
      alias JobMap = Hash(String, Array(String) | String | Shared::InlineJob | Shared::InlineJobRef | Shared::Container)
      include Jobable
    {% end %}
    {% if service %} include Serviceable {% end %}

    DECLARED << self

    def self.manifest_type
      {{ type }}
    end

    Macros.manifest(2, {{type}}, {{properties}}, {
      name:                            {type: String},
      automount_service_account_token: {type: Bool, optional: true},
      prefix:                          {type: String, optional: true},
      suffix:                          {type: String, optional: true},
      registry_host:                   {type: String, optional: true},
      registry_user:                   {type: String, optional: true},
      context:                         {type: String, optional: true},
      namespace:                       {type: String, optional: true},
      restart_policy:                  {type: String, optional: true},
      annotations:                     {type: StringMap, default: StringMap.new},
      labels:                          {type: StringMap, default: StringMap.new},
      config_map:                      {type: StringMap, default: StringMap.new},
      secrets:                         {type: StringMap, default: StringMap.new},
      affinity:                        {type: Pyrite::Api::Core::V1::Affinity, optional: true},
      init_containers:                 {type: ContainerMap, default: ContainerMap.new},
      containers:                      {type: ContainerMap},
      clusters:                        {type: ClusterMap, default: ClusterMap.new },
      {% if jobs %}
        jobs:                          {type: JobMap, default: JobMap.new},
        cron_jobs:                     {type: CronJobMap, default: CronJobMap.new},
      {% end %}
      {% if service %}
        ingress: {type: V1::Manifest::Ingress, optional: true},
        service: {type: String | V1::Manifest::Service, default: "ClusterIP", optional: true }
      {% end %}
    })
  end
end

require "./manifest/shared/*"
require "./manifest/*"
