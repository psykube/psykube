require "yaml"

class Psykube::Manifest::Ingress::Host
  alias PathStrings = Array(String)
  alias PathPortMap = Hash(String, String)

  YAML.mapping(
    tls: Tls | Nil | Bool,
    paths: PathStrings | PathPortMap
  )

  def initialize
    @paths = ["/"]
  end
end

require "./host/*"
