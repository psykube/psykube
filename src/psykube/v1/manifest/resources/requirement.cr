class Psykube::V1::Manifest::Resources::Requirement
  Manifest.mapping({
    cpu:    String?,
    memory: String?,
  })

  def self.new(cpu : String? = nil, memory : String? = nil)
    return unless cpu || memory
    allocate.tap do |req|
      req.cpu = cpu
      req.memory = memory
    end
  end
end
