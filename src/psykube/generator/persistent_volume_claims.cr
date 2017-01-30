require "../kubernetes/persistent_volume_claim"
require "./concerns/*"

class Psykube::Generator
  class PersistentVolumeClaims < Generator
    include Concerns::Volumes

    protected def result
      manifest_claims.map do |mount_path, volume|
        generate_persistent_volume_claim(mount_path, volume).as(Kubernetes::PersistentVolumeClaim).tap do |claim|
          claim.metadata.namespace = namespace
        end
      end unless manifest_claims.empty?
    end

    private def manifest_claims
      manifest_volumes.select { |k, v| volume_is_claim? v }
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
      volume_name = name_from_mount_path(mount_path)
      Kubernetes::PersistentVolumeClaim.new(volume_name, claim.size, claim.access_modes).tap do |pvc|
        if claim.storage_class
          pvc.metadata.annotations = {
            "volume.beta.kubernetes.io/storage-class" => claim.storage_class.as(String),
          }
        end
      end
    end

    private def generate_persistent_volume_claim(mount_path : String, nothing : Nil)
    end

    private def generate_persistent_volume_claim(mount_path : String, size : String)
      volume_name = name_from_mount_path(mount_path)
      Kubernetes::PersistentVolumeClaim.new(volume_name, size)
    end
  end
end
