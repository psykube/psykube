class Psykube::V1::Manifest::Autoscale
  Macros.mapping({
    min:                   {type: Int32, nilable: true},
    max:                   {type: Int32, default: 1},
    target_cpu_percentage: {type: Int32, nilable: true},
  })

  def merge(other : Psykube::V1::Manifest::Autoscale)
    other.dup.tap do |new|
      new.min ||= min
      new.target_cpu_percentage ||= target_cpu_percentage
    end
  end

  def initialize(*, @min : Int32? = nil, @max : Int32)
  end
end
