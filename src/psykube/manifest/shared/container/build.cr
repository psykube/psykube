class Psykube::Manifest::Shared::Container::Build
  class CacheFromTag
    Macros.mapping({
      tag: {type: String},
    })
  end

  Macros.mapping({
    dockerfile: {type: String, optional: true},
    tag:        {type: String | Array(String), optional: true},
    context:    {type: String, optional: true},
    cache_from: {type: String | Array(String | CacheFromTag), optional: true},
    stages:     {type: Array(String), optional: true},
    target:     {type: String, optional: true},
    args:       {type: StringableMap, default: StringableMap.new},
    platform:   {type: String, default: "linux/amd64"},
  })

  def_equals_and_hash dockerfile, context, args
end
