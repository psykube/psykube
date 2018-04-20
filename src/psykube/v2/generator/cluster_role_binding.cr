class Psykube::V2::Generator::ClusterRoleBinding < ::Psykube::Generator
  include Concerns::PodHelper
  cast_manifest Manifest

  protected def result
    generate_cluster_role_bindings(manifest.cluster_roles)
  end

  private def generate_cluster_role_bindings(nil : Nil)
    return [] of Pyrite::Api::Rbac::V1::ClusterRoleBinding
  end

  private def generate_cluster_role_bindings(cluster_roles : Array(Manifest::Shared::Role | String))
    cluster_roles.map do |cluster_role|
      generate_cluster_role_binding(cluster_role)
    end
  end

  private def generate_cluster_role_binding(name : String)
    Pyrite::Api::Rbac::V1::ClusterRoleBinding.new(
      metadata: generate_metadata(name: [self.name, name].join('-')),
      subjects: [generate_subject(manifest.service_account)],
      role_ref: Pyrite::Api::Rbac::V1::RoleRef.new(
        kind: "ClusterRole",
        name: name,
        api_group: ""
      )
    )
  end

  private def generate_cluster_role_binding(cluster_role : Manifest::Shared::Role)
    Pyrite::Api::Rbac::V1::ClusterRoleBinding.new(
      metadata: generate_metadata(name: [self.name, name].join('-')),
      subjects: [generate_subject(manifest.service_account)],
      role_ref: Pyrite::Api::Rbac::V1::RoleRef.new(
        kind: "ClusterRole",
        name: [self.name, cluster_role, name].join('-'),
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

  private def generate_subject(service_account : Manifest::Shared::ServiceAccount | Nil)
    generate_subject(self.name)
  end
end
