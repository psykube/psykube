require "yaml"
require "./namespace"
require "./service"
require "./config_map"
require "./ingress"
require "./secret"

class Psykube::Kubernetes::List
  alias ListableTypes = Psykube::Kubernetes::Namespace |
                        Psykube::Kubernetes::ConfigMap |
                        Psykube::Kubernetes::Service |
                        Psykube::Kubernetes::Ingress |
                        Psykube::Kubernetes::Secret

  YAML.mapping(
    api_version: {type: String, key: "apiVersion", default: "v1"},
    kind: {type: String, default: "List"},
    items: {type: Array(ListableTypes)}
  )

  def initialize(items)
    @api_version = "v1"
    @kind = "List"
    @items = Array(ListableTypes).new
    items.each { |item| @items.push item }
  end
end
