class Psykube::V2::Generator::ServiceAccount < ::Psykube::Generator
  include Concerns::PodHelper
  cast_manifest Manifest

  protected def result
    generate_service_account(manifest.service_account)
  end

  private def generate_service_account(name : String) : Nil
  end

  private def generate_service_account(nil : Nil)
    return unless manifest.roles || manifest.cluster_roles
    Pyrite::Api::Core::V1::ServiceAccount.new(
      metadata: generate_metadata
    )
  end

  private def generate_service_account(service_account : Manifest::Shared::ServiceAccount)
    Pyrite::Api::Core::V1::ServiceAccount.new(
      metadata: generate_metadata,
      automount_service_account_token: service_account.automount_token,
      image_pull_secrets: generate_image_pull_secrets(service_account.image_pull_secrets),
      secrets: generate_secret_refs(service_account.secrets)
    )
  end

  private def generate_secret_refs(nil : Nil) : Nil
  end

  private def generate_secret_refs(names : Array(Manifest::Shared::ObjectReference | String))
    names.map do |ref|
      generate_secret_ref ref
    end
  end

  private def generate_secret_ref(name : String)
    Pyrite::Api::Core::V1::ObjectReference.new(name: name)
  end

  private def generate_secret_ref(ref : Manifest::Shared::ObjectReference)
    Pyrite::Api::Core::V1::ObjectReference.new(
      api_version: ref.api_version,
      field_path: ref.field_path,
      kind: ref.kind,
      name: ref.name,
      namespace: ref.namespace,
      resource_version: ref.resource_version,
      uid: ref.uid,
    )
  end
end
