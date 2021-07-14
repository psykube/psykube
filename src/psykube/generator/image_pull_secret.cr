class Psykube::Generator::ImagePullSecret < ::Psykube::Generator
  include Concerns::PodHelper
  cast_manifest Manifest

  protected def result
    generate_image_pull_secrets(manifest.image_pull_secrets)
  end

  private def generate_image_pull_secrets(creds : Array(String | Manifest::Shared::PullSecretCredentials))
    creds.map do |cred|
      generate_image_pull_secret cred
    end.compact
  end

  private def generate_image_pull_secrets(_nil : Nil)
    [] of Pyrite::Api::Core::V1::Secret
  end

  private def generate_image_pull_secret(cred : Manifest::Shared::PullSecretCredentials)
    Pyrite::Api::Core::V1::Secret.new(
      metadata: generate_metadata(name: [name, cred.server].compact.join('-')),
      type: "kubernetes.io/dockerconfigjson",
      data: {
        ".dockerconfigjson" => Base64.urlsafe_encode(generate_cred(cred).to_json),
      }
    )
  end

  private def generate_image_pull_secret(any) : Nil
  end

  private def generate_cred(cred : Manifest::Shared::PullSecretCredentials)
    {
      "auths": {
        cred.server => {
          "username" => cred.username,
          "password" => cred.password,
          "email"    => cred.email,
          "auth"     => Base64.urlsafe_encode([cred.username, cred.password].join(':')),
        },
      },
    }
  end
end
