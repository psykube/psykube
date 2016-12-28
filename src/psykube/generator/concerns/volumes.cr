class Psykube::Generator
  module Concerns::Volumes
    private def name_from_mount_path(mount_path : String)
      [manifest.name, mount_path.gsub(/\//, "-")].join('-').downcase
    end

    private def manifest_volumes
      manifest.volumes || {} of String => Manifest::Volume | String
    end
  end
end
