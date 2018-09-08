class Psykube::V2::Generator::RoleBinding < ::Psykube::Generator
  include Concerns::PodHelper
  cast_manifest Manifest

  protected def result
    generate_role_bindings(manifest.roles)
  end

  private def generate_role_bindings(_nil : Nil)
    return [] of Pyrite::Api::Rbac::V1::RoleBinding
  end

  private def generate_role_bindings(roles : Array)
    roles.map do |role|
      generate_role_binding(role)
    end
  end

  private def generate_role_binding(name : String)
    Pyrite::Api::Rbac::V1::RoleBinding.new(
      metadata: generate_metadata(name: [self.name, name].join('-')),
      subjects: [generate_subject(manifest.service_account)],
      role_ref: Pyrite::Api::Rbac::V1::RoleRef.new(
        kind: "Role",
        name: name,
        api_group: ""
      )
    )
  end

  private def generate_role_binding(cluster_role : Manifest::Shared::ClusterRoleType)
    Pyrite::Api::Rbac::V1::RoleBinding.new(
      metadata: generate_metadata(name: [self.name, name].join('-')),
      subjects: [generate_subject(manifest.service_account)],
      role_ref: Pyrite::Api::Rbac::V1::RoleRef.new(
        kind: "ClusterRole",
        name: cluster_role.cluster_role,
        api_group: ""
      )
    )
  end

  private def generate_role_binding(role : Manifest::Shared::Role)
    Pyrite::Api::Rbac::V1::RoleBinding.new(
      metadata: generate_metadata(name: [self.name, name].join('-')),
      subjects: [generate_subject(manifest.service_account)],
      role_ref: Pyrite::Api::Rbac::V1::RoleRef.new(
        kind: "Role",
        name: [self.name, role.name].join('-'),
        api_group: ""
      )
    )
  end

  private def generate_subject(service_account_name : String)
    Pyrite::Api::Rbac::V1::Subject.new(
      kind: "ServiceAccount",
      name: service_account_name,
      namespace: namespace
    )
  end

  private def generate_subject(service_account : Manifest::Shared::ServiceAccount | Nil | Bool)
    generate_subject(self.name)
  end
end
