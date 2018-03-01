class Psykube::V2::Manifest::Deployment::Rollout
  Macros.mapping({
    progress_timeout: {type: Int32, nilable: true},
    history_limit:    {type: Int32, nilable: true},
    max_unavailable:  {type: Int32 | String, default: "25%"},
    max_surge:        {type: Int32 | String, default: "25%"},
  })
end
