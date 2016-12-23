require "yaml"
require "./namespace"
require "./service"
require "./config_map"
require "./ingress"
require "./deployment"
require "./secret"
require "./persistent_volume_claim"

class Psykube::Kubernetes::List
  alias ListableTypes = Psykube::Kubernetes::Namespace |
                        Psykube::Kubernetes::ConfigMap |
                        Psykube::Kubernetes::Service |
                        Psykube::Kubernetes::Ingress |
                        Psykube::Kubernetes::Deployment |
                        Psykube::Kubernetes::Secret |
                        Psykube::Kubernetes::PersistentVolumeClaim

  YAML.mapping(
    api_version: {type: String, key: "apiVersion", default: "v1"},
    kind: {type: String, default: "List"},
    items: {type: Array(ListableTypes)}
  )

  def initialize(&block : List -> _)
    initialize
    yield self
  end

  def initialize
    @api_version = "v1"
    @kind = "List"
    @items = Array(ListableTypes).new
  end

  def initialize(items : Array(ListableTypes | Nil))
    initialize
    concat(items)
  end

  def concat(items : Nil)
  end

  def concat(items : Array(ListableTypes | Nil))
    items.each { |item| self << item }
  end

  def <<(item : ListableTypes)
    @items << item
  end

  def <<(item : Nil)
  end
end
