require "../../../concerns/mapping"

class Psykube::Kubernetes::Ingress::Spec::Tls
  Kubernetes.mapping(
    hosts: Array(String),
    secret_name: String
  )

  def initialize(host : String)
    initialize(host, nil)
  end

  def initialize(host : String, secret_name : String?)
    initialize([host], secret_name || host.downcase.gsub(/\./, "-"))
  end

  def initialize(hosts : Array(String), secret_name : String)
    @hosts = hosts
    @secret_name = secret_name
  end
end
