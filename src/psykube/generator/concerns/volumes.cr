class Psykube::Generator
  module Concerns::Volumes
    private def name_from_mount_path(mount_path : String)
      [cluster_name, manifest.name, mount_path.gsub(/\//, "-")].join('-')
    end

    private def manifest_volumes
      manifest.volumes || {} of String => Manifest::Volume | String
    end
  end
end
