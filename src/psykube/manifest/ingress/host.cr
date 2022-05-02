require "./tls"

class Psykube::Manifest::Ingress::Host
  alias PathList = Array(String)
  alias PathMap = Hash(String?, Path)

  Macros.mapping({
    tls:          {type: Tls | Bool, optional: true},
    port:         {type: Int32 | String, optional: true},
    service_name: {type: String, optional: true},
    path:         {type: String, optional: true},
    paths:        {type: PathList | PathMap, optional: true},
  })

  def_clone

  def initialize(*, @port = nil, @service_name = nil, @path = nil, @paths = nil, @tls = nil)
  end

  def paths
    path = @path
    paths = @paths
    path_map = case paths
               when PathMap
                 paths.tap(&.each do |_, p|
                   p.port ||= port
                   p.service_name ||= service_name
                 end)
               when PathList
                 paths.each_with_object(PathMap.new) do |path_string, map|
                   map[path_string] = Path.new(port: port, service_name: service_name)
                 end
               else
                 PathMap.new
               end
    path_map[path] if path_map.empty?
    path_map
  end
end

require "./host/*"
