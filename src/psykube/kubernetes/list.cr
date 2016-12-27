require "./namespace"
require "./service"
require "./config_map"
require "./ingress"
require "./deployment"
require "./secret"
require "./persistent_volume_claim"
require "./concerns/resource"

class Psykube::Kubernetes::List
  alias ListableTypes = Namespace |
                        ConfigMap |
                        Service |
                        Ingress |
                        Deployment |
                        Secret |
                        PersistentVolumeClaim
  Resource.definition("v1", "List", {
    items: {type: Array(ListableTypes)},
  })

  def initialize(&block : List -> _)
    initialize
    yield self
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
