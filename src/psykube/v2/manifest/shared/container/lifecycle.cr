class Psykube::V2::Manifest::Shared::Container::Lifecycle
  Macros.mapping({
    post_start: {type: Handler, optional: true},
    pre_stop:  {type: Handler, optional: true}
  })
end
