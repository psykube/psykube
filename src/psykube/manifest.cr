module Psykube::Manifest
  def self.new(*args, **params)
    V1::Manifest.new(*args, **params)
  end

  alias Default = V1
  alias Resources = Default::Manifest::Resources
  alias Env = Default::Manifest::Env
  alias Cluster = Default::Manifest::Cluster
  alias Ingress = Default::Manifest::Ingress
  alias Any = V1::Manifest
end
