class Psykube::Manifest::Autoscale
  Manifest.mapping({
    min: {type: UInt8},
    max: {type: UInt8},
  })

  def initialize
    @min = 1.to_u8
    @max = 1.to_u8
  end

  def initialize(@min : UInt8, @max : UInt8)
  end
end
