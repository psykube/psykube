require "yaml"

class Psykube::Kubernetes::Ingress::Spec::Tls
  YAML.mapping(
    hosts: {type: Array(String)},
    secret_name: {type: String, key: "secretName"}
  )

  def initialize(host : String)
    initialize(host, nil)
  end

  def initialize(host : String, secret_name : String | Nil)
    initialize([host], secret_name || host.downcase.gsub(/\./, "-"))
  end

  def initialize(hosts : Array(String), secret_name : String)
    @hosts = hosts
    @secret_name = secret_name
  end
end
