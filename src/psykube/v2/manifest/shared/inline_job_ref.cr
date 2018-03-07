class Psykube::V2::Manifest::Shared::InlineJobRef
  Macros.mapping({
    container:       {type: String},
    env:             {type: EnvMap, default: EnvMap.new},
    volumes:         {type: VolumeMap, default: VolumeMap.new},
    restart_policy:  {type: String, optional: true},
    command:         {type: String?},
    args:            {type: Array(String)?},
    active_deadline: {type: Int32, optional: true},
    backoff_limit:   {type: Int32, optional: true},
    completions:     {type: Int32, optional: true},
    parallelism:     {type: Int32, optional: true},
  })

  def init_containers
    ContainerMap.new
  end
end
