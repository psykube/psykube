class Psykube::V2::Generator::Role < ::Psykube::Generator
  include Concerns::PodHelper
  cast_manifest Manifest

  protected def result
    generate_roles(manifest.roles)
  end

  private def generate_roles(nil : Nil)
    return [] of Pyrite::Api::Rbac::V1::Role
  end

  private def generate_roles(roles : Array(Manifest::Shared::Role | String))
    roles.map do |role|
      generate_role(role)
    end.compact
  end

  private def generate_role(name : String) : Nil
  end

  private def generate_role(role : Manifest::Shared::Role)
    rules = role.rules.map do |rule|
      Pyrite::Api::Rbac::V1::PolicyRule.new(
        api_groups: rule.api_groups,
        non_resource_urls: rule.non_resource_urls,
        resource_names: rule.resource_names,
        resources: rule.resources,
        verbs: rule.verbs
      )
    end
    Pyrite::Api::Rbac::V1::Role.new(
      metadata: generate_metadata(name: [self.name, role.name].join('-')),
      rules: rules
    )
  end
end
