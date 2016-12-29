require "yaml"

class Psykube::Manifest::Ingress::Host
  alias PathList = Array(String)
  alias PathMap = Hash(String, Path)

  YAML.mapping(
    tls: Tls | Nil | Bool,
    port: {type: UInt16 | String, default: "default"},
    path: {type: String, default: "/"},
    paths: {type: PathList | PathMap, nilable: true, getter: false}
  )

  def initialize
    @path = "/"
    @port = "default"
  end

  def paths
    paths = @paths
    path_map = case paths
               when PathMap
                 paths
               when PathList
                 paths.each_with_object(PathMap.new) do |path, map|
                   map[path] = Path.new(@port)
                 end
               else
                 PathMap.new
               end
    path_map[@path] = Path.new(@port) if paths
    path_map
  end
end

require "./host/*"
