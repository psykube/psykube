class Psykube::Manifest::V2::Deployment::Rollout
  Manifest.mapping({
    progress_timeout: Int32?,
    history_limit:    Int32?,
    max_unavailable:  {type: Int32, nilable: true, getter: false},
    max_surge:        {type: Int32, nilable: true, getter: false},
  })

  def max_unavailable
    @max_unavailable || "25%"
  end

  def max_surge
    @max_surge || "25%"
  end
end
