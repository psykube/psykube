abstract class Psykube::Generator
  module Concerns::Volumes
    private def name_from_mount_path(mount_path : String)
      [name, mount_path.gsub(/\//, "-")].join('-').downcase
    end

    private def manifest_volumes
      manifest.volumes || Manifest::VolumeMap.new
    end
  end
end
