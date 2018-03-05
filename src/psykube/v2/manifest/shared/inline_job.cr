class Psykube::V2::Manifest::Shared::InlineJob
  delegate env, volumes, to: container

  Macros.mapping({
    container:       {type: Shared::Container},
    active_deadline: {type: Int32, optional: true},
    backoff_limit:   {type: Int32, optional: true},
    restart_policy:  {type: String, optional: true},
    completions:     {type: Int32, optional: true},
    parallelism:     {type: Int32, optional: true},
  })

  def init_containers
    ContainerMap.new
  end
end
