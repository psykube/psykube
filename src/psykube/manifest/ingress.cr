class Psykube::Manifest::Ingress
  alias HostHash = Hash(String, Host)
  alias HostnameList = Array(String)

  Macros.mapping({
    annotations:  {type: StringableMap, optional: true},
    tls:          {type: Tls | Bool, optional: true},
    host:         {type: String, optional: true},
    hosts:        {type: HostnameList | HostHash, optional: true},
    port:         {type: Int32 | String, optional: true},
    service_name: {type: String, optional: true},
    path:         {type: String, optional: true},
    paths:        {type: Host::PathList | Host::PathMap, optional: true},
  })

  def initialize(hosts : Array(String), @tls : Bool? = nil)
    if hosts.size == 1
      @host = hosts.first
    elsif hosts.size > 1
      @hosts = hosts
    end
  end

  def hosts?
    !@hosts.nil?
  end

  def hosts
    host_hash = case (hosts = @hosts)
                when HostHash
                  hosts
                when HostnameList
                  hosts.each_with_object(HostHash.new) do |hostname, new_hash|
                    new_hash[hostname] = Host.new(service_name: service_name, port: port, path: path, paths: paths)
                  end
                else
                  HostHash.new
                end
    if (host = @host)
      host_hash[host] = Host.new(service_name: service_name, port: port, path: path, paths: paths)
    end
    host_hash
  end
end

require "./ingress/*"
