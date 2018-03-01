class Psykube::V2::Manifest::Shared::Container
  Manifest.mapping({
    image:         String?,
    tag:           String?,
    build_context: {type: String, default: "."},
    build_args:    {type: StringMap, default: StringMap.new},
    ports:         {type: PortMap, default: PortMap.new},
    volumes:       {type: VolumeMap, nilable: true},
    env:           {type: Hash(String, V1::Env | String), nilable: true, getter: false},
  })

  def env
    env = @env || {} of String => Env | String
    return env unless ports?
    env["PORT"] = lookup_port("default").to_s
    ports.each_with_object(env) do |(name, port), env|
      env["#{name.underscore.upcase.gsub(/(-\.)/, "_")}_PORT"] = port.to_s
    end
  end
end
