class Psykube::Manifest::Resources
  Manifest.mapping({
    limits:   Requirement?,
    requests: Requirement?,
  })

  def self.new(cpu_request : String? = nil, memory_request : String? = nil, cpu_limit : String? = nil, memory_limit : String? = nil)
    return unless cpu_request || memory_request || cpu_limit || memory_limit
    allocate.tap do |resources|
      resources.requests = Requirement.new cpu_request, memory_request
      resources.limits = Requirement.new cpu_limit, memory_limit
    end
  end
end

require "./resources/*"
