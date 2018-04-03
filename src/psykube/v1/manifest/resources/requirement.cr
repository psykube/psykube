class Psykube::V1::Manifest::Resources::Requirement
  Macros.mapping({
    cpu:    {type: String, optional: true},
    memory: {type: String, optional: true},
  })

  def self.new(cpu : String? = nil, memory : String? = nil)
    return unless cpu || memory
    allocate.tap do |req|
      req.cpu = cpu
      req.memory = memory
    end
  end
end
