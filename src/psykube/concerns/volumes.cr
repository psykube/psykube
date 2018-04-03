module Psykube::Concerns::Volumes
  private def name_from_mount_path(mount_path : String)
    [name, mount_path.gsub(/\//, "-")].join('-').downcase
  end
end
