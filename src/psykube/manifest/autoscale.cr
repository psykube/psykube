require "yaml"

class Psykube::Manifest::Autoscale
  YAML.mapping({
    min: {type: UInt8},
    max: {type: UInt8},
  }, true)

  def initialize
    @min = 1.to_u8
    @max = 1.to_u8
  end

  def initialize(@min : UInt8, @max : UInt8)
  end
end
