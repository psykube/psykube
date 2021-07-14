class Psykube::Manifest::Shared::ContainerOverides
  Macros.mapping({
    dockerfile: {type: String, optional: true},
    build_args: {type: StringableMap, default: StringableMap.new},
  })
end
