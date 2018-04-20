class Psykube::V2::Manifest::Shared::Container::Build
  Macros.mapping({
    context: {type: String, default: "."},
    args:    {type: StringMap, default: StringMap.new},
  })
end
