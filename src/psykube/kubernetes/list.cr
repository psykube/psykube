require "./namespace"
require "./service"
require "./config_map"
require "./ingress"
require "./deployment"
require "./secret"
require "./pod"
require "./persistent_volume_claim"
require "./horizontal_pod_autoscaler"
require "./concerns/resource"
require "./concerns/resource"

class Psykube::Kubernetes::List
  alias ListableTypes = Namespace |
                        ConfigMap |
                        Service |
                        Ingress |
                        Deployment |
                        Secret |
                        PersistentVolumeClaim |
                        Pod |
                        HorizontalPodAutoscaler

  delegate :select, :[], :[]?, :find, :unshift, to: @items

  Resource.definition("v1", "List", {
    items:            {type: Array(ListableTypes), default: [] of ListableTypes},
    resource_version: String?,
    self_link:        String?,
  })

  def initialize(&block : List -> _)
    initialize
    yield self
  end

  def initialize(items : Array(ListableTypes?))
    initialize
    concat(items)
  end

  def concat(items : Nil)
  end

  def concat(items : Array(ListableTypes?))
    items.each { |item| self << item }
  end

  def <<(item : ListableTypes)
    @items << item
  end

  def <<(item : Nil)
  end

  def clean!
    @items.each(&.clean!)
    self
  end
end
