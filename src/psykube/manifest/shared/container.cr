class Psykube::Manifest::Shared::Container
  class PortError < Psykube::Error
  end

  Macros.mapping({
    image:             {type: String, optional: true},
    image_pull_policy: {type: String, optional: true},
    tag:               {type: String, optional: true},
    working_dir:       {type: String, optional: true},
    build:             {type: Build, optional: true},
    healthcheck:       {type: Bool | Manifest::Healthcheck, optional: true, default: false},
    readycheck:        {type: Bool | Manifest::Readycheck, optional: true, default: false},
    ports:             {type: PortMap, default: PortMap.new},
    volumes:           {type: Hash(String, String | VolumeMount), optional: true},
    volume_mounts:     {type: Hash(String, String | VolumeMount), optional: true},
    resources:         {type: Manifest::Resources, optional: true},
    env:               {type: Hash(String, Manifest::Env | String | Int32 | Bool | Float64 | Nil), optional: true},
    command:           {type: Array(String) | String, optional: true},
    args:              {type: Array(String) | String, optional: true},
    security_context:  {type: SecurityContext, optional: true},
    lifecycle:         {type: Lifecycle, optional: true},
  })

  def env
    env = @env || {} of String => Manifest::Env | String | Int32 | Bool | Float64 | Nil
    return env unless ports?
    env["PORT"] = lookup_port.to_s
    ports.each_with_object(env) do |(name, port), env|
      env["#{name.underscore.upcase.gsub(/(-\.)/, "_")}_PORT"] = port.to_s
    end
  end

  def ports?
    !ports.empty?
  end

  def lookup_port!(port_name : Nil = nil)
    ports["default"]? || ports.values.first? || raise PortError.new "Container does not export any ports"
  end

  def lookup_port!(port_number : Int32)
    raise PortError.new "Container does not export port #{port_number}" unless ports.values.includes? port_number
    port_number
  end

  def lookup_port!(port_name : String)
    if (port_int = port_name.to_i?)
      lookup_port! port_int
    else
      ports[port_name]? || raise PortError.new "No port named #{port_name}"
    end
  end

  def lookup_port(port : Int32 | String | Nil = nil)
    lookup_port!(port)
  rescue PortError
    nil
  end
end

require "./container/*"
