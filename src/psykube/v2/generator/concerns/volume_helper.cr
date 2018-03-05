module Psykube::V2::Generator::Concerns::VolumeHelper
  extend self

  # Volume Mounts
  def generate_container_volume_mounts(volumes : VolumeMap)
    return if volumes.empty?
    volumes.map do |mount_path, volume|
      volume_name = Psykube::Concerns::Volumes.name_from_mount_path(mount_path)
      Pyrite::Api::Core::V1::VolumeMount.new(
        name: volume_name,
        mount_path: mount_path
      )
    end
  end

  # Volumes
  def generate_volumes(volumes)
    volumes.map do |mount_path, spec|
      generate_volume(mount_path, spec)
    end unless volumes.empty?
  end

  private def generate_volume(mount_path : String, size : String)
    volume_name = Psykube::Concerns::Volumes.name_from_mount_path(mount_path)
    Pyrite::Api::Core::V1::Volume.new(
      name: volume_name,
      persistent_volume_claim: Pyrite::Api::Core::V1::PersistentVolumeClaimVolumeSource.new(
        claim_name: volume_name
      )
    )
  end

  private def generate_volume(mount_path : String, volume : V1::Manifest::Volume)
    volume_name = Psykube::Concerns::Volumes.name_from_mount_path(mount_path)
    volume.to_deployment_volume(name: name, volume_name: volume_name)
  end
end
