class Psykube::Manifest::StatefulSet < ::Psykube::Manifest
  declare("StatefulSet", {
    parallel:      {type: Bool, optional: true},
    service_name:  {type: String, optional: true},
    ready_timeout: {type: Int32, optional: true},
    replicas:      {type: Int32, optional: true},
    recreate:      {type: Bool, optional: true},
    rollout:       {type: Rollout, optional: true},
  }, jobable: true)

  def rollout
    case @rollout
    when .nil?
      Rollout.new
    when true
      @rollout
    end
  end

  def service_name
    if (service_name = @service_name)
      return validate_service_name(service_name)
    end
    case (services = @services)
    when Array(String)
      [name, services.first.downcase].join('-')
    when Hash
      [name, services.keys.first].join('-')
    end
  end

  def validate_service_name(service_name : String)
    if (services = @services).is_a? Hash
      raise Error.new "Invalid service name: #{service_name}" unless services[service_name]?
      return name if service_name == "default"
      [name, service_name].join('-')
    else
      raise Error.new "No named services"
    end
  end
end

require "./stateful_set/*"
