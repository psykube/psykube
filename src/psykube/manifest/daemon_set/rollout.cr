class Psykube::Manifest::DaemonSet::Rollout
  Macros.mapping({
    history_limit:   {type: Int32, optional: true},
    max_unavailable: {type: Int32 | String, default: "25%"},
  })
end
