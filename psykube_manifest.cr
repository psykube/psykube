require "yaml"

class PsykubeManifest
  YAML.mapping(
    name: String,
    registry_host: String | Nil,
    registry_user: String,
    tags: {type: Array(String), default: [] of String},
    env: {type: Hash(String, EnvObject | String), default: {} of String => EnvObject | String},
    ingress: IngressObject | Nil,
    service: {type: Bool, default: true},
    configMap: {type: Hash(String, String), default: {} of String => String},
    secrets: {type: Hash(String, String), default: {} of String => String},
    ports: {type: Hash(String, UInt16), default: {} of String => UInt16},
    clusters: {type: Hash(String, ClusterObject), default: {} of String => ClusterObject},
  )

  def change
    self.name = "Hello"
    self
  end

  class IngressObject
    YAML.mapping(
      tls: TlsObject,
    )
  end

  class TlsObject
    YAML.mapping(
      acme: Bool | Nil,
    )
  end

  class EnvObject
    YAML.mapping(
      configMap: String | ConfigMapObject | Nil,
      secret: String | SecretObject | Nil
    )

    class ConfigMapObject
      YAML.mapping(
        name: String | Nil,
        key: String | Nil
      )
    end

    class SecretObject
      YAML.mapping(
        name: String | Nil,
        key: String | Nil
      )
    end
  end

  class ClusterObject
    YAML.mapping(
      ingress: IngressObject | Nil,
      configMap: Hash(String, String) | Nil,
      secrets: Hash(String, String) | Nil,
    )

    class IngressObject
      YAML.mapping(
        hosts: Hash(String, HostObject),
      )

      class HostObject
        YAML.mapping(
          tls: TlsObject | Nil,
          paths: Array(String) | Hash(String, PathObject)
        )

        class TlsObject
          YAML.mapping(
            acme: {type: Bool, default: false}
          )
        end

        class PathObject
          YAML.mapping(
            port: UInt16
          )
        end
      end
    end
  end
end
