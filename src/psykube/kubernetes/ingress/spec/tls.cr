require "digest/sha1"
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
    secret_name ||= "cert-" + Digest::SHA1.hexdigest(host.downcase)
    initialize([host], secret_name)
  end

  def initialize(hosts : Array(String), secret_name : String)
    @hosts = hosts
    @secret_name = secret_name
  end
end
