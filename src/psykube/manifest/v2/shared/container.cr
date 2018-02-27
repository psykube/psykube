class Psykube::Manifest::V2::Shared::Container
  Manifest.mapping({
    image:         String?,
    build_context: {type: String, default: "."},
    build_args:    {type: Hash(String, String), nilable: true, getter: false},
    ports:         {type: Hash(String, Int32), nilable: true, getter: false},
    volumes:       {type: V1::VolumeMap, nilable: true},
    env:           {type: Hash(String, V1::Env | String), nilable: true, getter: false},
  })

  def ports
    @ports || {} of String => Int32
  end

  def build_args
    @build_args || {} of String => String
  end

  def env
    env = @env || {} of String => Env | String
    return env unless ports?
    env["PORT"] = lookup_port("default").to_s
    ports.each_with_object(env) do |(name, port), env|
      env["#{name.underscore.upcase.gsub(/(-\.)/, "_")}_PORT"] = port.to_s
    end
  end
end
