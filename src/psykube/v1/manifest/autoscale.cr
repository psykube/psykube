class Psykube::V1::Manifest::Autoscale
  Manifest.mapping({
    min:                   Int32?,
    max:                   Int32,
    target_cpu_percentage: Int32?,
  })

  def initialize
    @max = 1
  end

  def merge(other : Psykube::V1::Manifest::Autoscale)
    other.dup.tap do |new|
      new.min ||= min
      new.target_cpu_percentage ||= target_cpu_percentage
    end
  end

  def initialize(@min : Int32?, @max : Int32)
  end
end
