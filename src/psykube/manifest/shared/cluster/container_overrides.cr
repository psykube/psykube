class Psykube::Manifest::Shared::ContainerOverides
  Macros.mapping({
    dockerfile: {type: String, optional: true},
    build_args: {type: StringMap, default: StringMap.new},
  })
end
