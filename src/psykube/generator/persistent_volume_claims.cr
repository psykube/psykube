class Psykube::Generator::PersistentVolumeClaims < ::Psykube::Generator
  include ::Psykube::Concerns::Volumes
  cast_manifest Manifest

  protected def result
    generate_persistent_volume_claims(combined_volumes)
  end

  private def volume_is_claim?(volume : String | Manifest::Volume::Claim)
    true
  end

  private def volume_is_claim?(any)
    false
  end

  private def generate_persistent_volume_claims(volumes : VolumeMap)
    volumes.select { |k, v| volume_is_claim? v }.map do |name, volume|
      generate_persistent_volume_claim(name, volume)
    end.compact
  end

  private def generate_persistent_volume_claims(any)
    [] of Pyrite::Api::Core::V1::PersistentVolumeClaim
  end

  private def generate_persistent_volume_claim(name : String, volume : Manifest::Volume)
    generate_persistent_volume_claim(name, volume.claim)
  end

  private def generate_persistent_volume_claim(name : String, claim : Manifest::Volume::Claim)
    volume_name = [self.name, name].join('-')
    Pyrite::Api::Core::V1::PersistentVolumeClaim.new(
      metadata: generate_metadata(name: volume_name, annotations: [claim.annotations], psykube_meta: false),
      spec: Pyrite::Api::Core::V1::PersistentVolumeClaimSpec.new(
        storage_class_name: claim.storage_class,
        access_modes: claim.access_modes || ["ReadWriteOnce"],
        resources: Pyrite::Api::Core::V1::ResourceRequirements.new(
          requests: {
            "storage" => claim.size,
          }
        )
      )
    )
  end

  private def generate_persistent_volume_claim(name : String, size : String)
    volume_name = [self.name, name].join('-')
    Pyrite::Api::Core::V1::PersistentVolumeClaim.new(
      metadata: generate_metadata(name: volume_name),
      spec: Pyrite::Api::Core::V1::PersistentVolumeClaimSpec.new(
        access_modes: ["ReadWriteOnce"],
        resources: Pyrite::Api::Core::V1::ResourceRequirements.new(
          requests: {
            "storage" => size,
          }
        )
      )
    )
  end

  private def generate_persistent_volume_claim(name : String, any) : Nil
  end
end
