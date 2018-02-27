class Psykube::Manifest::V1::Resources
  Manifest.mapping({
    limits:   Requirement?,
    requests: Requirement?,
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
