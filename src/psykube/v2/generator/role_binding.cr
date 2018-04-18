class Psykube::V2::Generator::RoleBinding < ::Psykube::Generator
  include Concerns::PodHelper
  cast_manifest Manifest

  protected def result
    generate_role_bindings(manifest.roles)
  end

  private def generate_role_bindings(nil : Nil)
    return [] of Pyrite::Api::Rbac::V1::RoleBinding
  end

  private def generate_role_bindings(roles : Array(Manifest::Shared::Role | String))
    cluster_roles.keys.map do |cluster_role|
      generate_cluster_role_binding(ClusterRole)
    end
  end

  private def generate_cluster_role_binding(name : String)
    Pyrite::Api::Rbac::V1::ClusterRoleBinding.new(
      metadata: generate_metadata([self.name, name].join('-')),
      subjects: [generate_subject(manifest.service_account)],
      role_ref: Pyrite::Api::Rbac::V1::RoleRef.new(
        kind: "ClusterRole",
        name: name
      )
    )
  end

  private def generate_cluster_role_binding(cluster_role : Manifest::Shared::Role)
    Pyrite::Api::Rbac::V1::ClusterRoleBinding.new(
      metadata: generate_metadata([self.name, name].join('-')),
      subjects: [generate_subject(manifest.service_account)],
      role_ref: Pyrite::Api::Rbac::V1::RoleRef.new(
        kind: "ClusterRole",
        name: [self.name, cluster_role,name].join('-')
      )
    )
  end

  private def generate_subject(service_account_name : String)
    Pyrite::Api::Rbac::V1::Subject.new(
      kind: "ServiceAccount",
      name: service_account_name
    )
  end

  private def generate_subject(service_account : Manifest::Shared::ServiceAccount | Nil)
    generate_subject(self.name)
  end
end
