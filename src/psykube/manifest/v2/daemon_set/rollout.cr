class Psykube::Manifest::V2::DaemonSet::Rollout
  Manifest.mapping({
    history_limit:   Int32?,
    max_unavailable: {type: Int32, nilable: true, getter: false},
  })

  def max_unavailable
    @max_unavailable || "25%"
  end
end
