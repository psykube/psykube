require "yaml"

class Psykube::Manifest::Ingress
  alias HostHash = Hash(String, Host)
  alias HostnameList = Array(String)

  YAML.mapping({
    annotations: Hash(String, String) | Nil,
    tls:         Bool | Nil,
    hosts:       {type: HostnameList | HostHash, nilable: true, getter: false},
  }, true)

  def hosts?
    !@hosts.nil?
  end

  def hosts
    hosts = @hosts
    case hosts
    when Nil
      HostHash.new
    when HostHash
      hosts
    when HostnameList
      hosts.each_with_object(HostHash.new) do |hostname, host_hash|
        host_hash[hostname] = Host.new
      end
    end
  end

  def initialize
  end
end

require "./ingress/*"
