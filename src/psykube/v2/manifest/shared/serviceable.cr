module Psykube::V2::Manifest::Serviceable
  def ports?
    !ports.empty?
  end

  def lookup_port(port : Int32)
    port
  end

  def ports
    containers.each_with_object(PortMap.new) do |(container_name, container), port_map|
      container.ports.each do |port_name, port|
        port_map[port_name] ||= port
      end
    end
  end

  def lookup_port(port_name : String)
    if port_name.to_i?
      port_name.to_i
    elsif port_name == "default" && !ports.key?("default")
      ports.values.first
    else
      ports[port_name]? || raise "Invalid port #{port_name}"
    end
  end
end
