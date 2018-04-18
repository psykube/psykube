class Psykube::V2::Generator::ClusterRole < ::Psykube::Generator
  include Concerns::PodHelper
  cast_manifest Manifest

  protected def result
    generate_cluster_roles(manifest.cluster_roles)
  end

  private def generate_cluster_roles(nil : Nil)
    return [] of Pyrite::Api::Rbac::V1::ClusterRole
  end

  private def generate_cluster_roles(cluster_roles : Array(Manifest::Shared::Role | String))
    cluster_roles.map do |role|
      generate_cluster_role(role)
    end.compact
  end

  private def generate_cluster_role(name : String) : Nil
  end

  private def generate_cluster_role(cluster_role : Manifest::Shared::Role)
    rules = cluster_role.rules.map do |rule|
      Pyrite::Api::Rbac::V1::PolicyRule.new(
        api_groups: rule.api_groups,
        non_resource_urls: rule.non_resource_urls,
        resource_names: rule.resource_names,
        resources: rule.resources,
        verbs: rule.verbs
      )
    end
    Pyrite::Api::Rbac::V1::ClusterRole.new(
      metadata: generate_metadata(name: [self.name, cluster_role.name].join('-')),
      rules: rules
    )
  end
end
