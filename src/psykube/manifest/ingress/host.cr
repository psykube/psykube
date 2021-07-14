require "./tls"

class Psykube::Manifest::Ingress::Host
  alias PathList = Array(String)
  alias PathMap = Hash(String?, Path)

  Macros.mapping({
    tls:   {type: Tls | Bool, optional: true},
    port:  {type: Int32 | String, default: "default"},
    path:  {type: String, optional: true},
    paths: {type: PathList | PathMap, optional: true},
  })

  def initialize
    @port = "default"
  end

  def paths
    paths = @paths
    path_map = case paths
               when PathMap
                 paths
               when PathList
                 paths.each_with_object(PathMap.new) do |path, map|
                   map[path] = Path.new(port)
                 end
               else
                 PathMap.new
               end
    path_map[path] = Path.new(port)
    path_map
  end
end

require "./host/*"
