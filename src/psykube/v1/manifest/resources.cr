class Psykube::V1::Manifest::Resources
  Macros.mapping({
    limits:   {type: Requirement, optional: true},
    requests: {type: Requirement, optional: true},
  })

  def self.from_flags(cpu_request : String? = nil, memory_request : String? = nil, cpu_limit : String? = nil, memory_limit : String? = nil)
    return unless cpu_request || memory_request || cpu_limit || memory_limit
    new.tap do |resources|
      resources.requests = Requirement.new cpu_request, memory_request
      resources.limits = Requirement.new cpu_limit, memory_limit
    end
  end

  def initialize
  end
end

require "./resources/*"
