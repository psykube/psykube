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

  def_clone

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

  def merge(other : self)
    clone.merge!(other)
  end

  def merge!(other : self)
    annotations = @annotations
    other_annotations = other.@annotations
    @annotations = annotations.nil? ? other.@annotations : annotations.merge(other_annotations) unless other_annotations.nil?
    @tls = other.@tls unless other.@tls.nil?
    @host = other.@host unless other.@host.nil?
    @hosts = other.@hosts unless other.@hosts.nil?
    @port = other.@port unless other.@port.nil?
    @service_name = other.@service_name unless other.@service_name.nil?
    @path = other.@path unless other.@path.nil?
    @paths = other.@paths unless other.@paths.nil?
    self
  end

  def hosts
    host_hash = case (hosts = @hosts)
                when HostHash
                  hosts.tap(&.each do |_, host|
                    host.service_name ||= service_name
                    host.paths ||= paths
                    host.path ||= path
                    host.port ||= port
                    host.tls ||= tls if host.tls.nil?
                  end)
                when HostnameList
                  hosts.each_with_object(HostHash.new) do |hostname, new_hash|
                    new_hash[hostname] = Host.new(service_name: service_name, port: port, path: path, paths: paths, tls: tls)
                  end
                else
                  HostHash.new
                end
    if (host = @host)
      host_hash[host] = Host.new(service_name: service_name, port: port, path: path, paths: paths, tls: tls)
    end
    host_hash
  end
end

require "./ingress/*"
