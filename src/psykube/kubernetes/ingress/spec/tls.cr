require "digest/sha1"
require "../../../concerns/mapping"

class Psykube::Kubernetes::Ingress::Spec::Tls
  Kubernetes.mapping(
    hosts: Array(String),
    secret_name: String
  )

  def initialize(host : String, prefix : String = "", suffix : String = "")
    secret_name = "cert-" + prefix + Digest::SHA1.hexdigest(host.downcase) + suffix
    initialize(host, secret_name)
  end

  def initialize(host : String, secret_name : String)
    initialize([host], secret_name)
  end

  def initialize(hosts : Array(String), secret_name : String)
    @hosts = hosts
    @secret_name = secret_name
  end
end
