class Psykube::V2::Manifest::Shared::Container::Build
  Macros.mapping({
    dockerfile: {type: String, optional: true},
    context: {type: String, optional: true},
    args:    {type: StringMap, default: StringMap.new},
  })
end
