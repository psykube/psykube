class Psykube::V1::Generator::PersistentVolumeClaims < ::Psykube::Generator
  def result
    result = manifest_claims.map do |mount_path, volume|
      generate_persistent_volume_claim(mount_path, volume)
    end.compact
    result unless result.empty?
  end

  private def manifest_claims
    manifest.volumes.select { |k, v| volume_is_claim? v }.compact
  end

  private def volume_is_claim?(volume : Manifest::Volume)
    !!volume.claim
  end

  private def volume_is_claim?(volume : String)
    true
  end

  private def generate_persistent_volume_claim(mount_path : String, volume : Manifest::Volume)
    generate_persistent_volume_claim(mount_path, volume.claim)
  end

  private def generate_persistent_volume_claim(mount_path : String, claim : Manifest::Volume::Claim)
    volume_name = Psykube::Concerns::Volumes.name_from_mount_path(mount_path)
    Pyrite::Api::Core::V1::PersistentVolumeClaim.new(
      metadata: generate_metadata(name: volume_name, annotations: [claim.annotations]),
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

  private def generate_persistent_volume_claim(mount_path : String, nothing : Nil)
  end

  private def generate_persistent_volume_claim(mount_path : String, size : String)
    volume_name = Psykube::Concerns::Volumes.name_from_mount_path(mount_path)
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
end
