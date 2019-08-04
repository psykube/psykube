def Psykube::V2::Manifest.new(command : Psykube::CLI::Commands::Init)
  flags = command.flags
  name = flags.name || File.basename(Dir.current)

  # Build container
  container = flags.image ? Shared::Container.new(image: flags.image) : Shared::Container.new

  # Set Resources
  container.resources = V1::Manifest::Resources.from_flags(
    flags.cpu_request,
    flags.memory_request,
    flags.cpu_limit,
    flags.memory_limit
  )

  # Set container ENV
  container.env = flags.env.map(&.split('=')).each_with_object(Hash(String, Manifest::Env | String | Int32 | Bool | Float64 | Nil).new) do |(k, v), memo|
    memo[k] = v
  end unless flags.env.empty?

  # Set Ports
  container.ports = Hash(String, Int32).new.tap do |hash|
    flags.ports.each_with_index do |spec, index|
      parts = spec.split("=", 2).reverse
      port = parts[0].to_i? || raise "Invalid port format."
      port_name = parts[1]? || (index == 0 ? "default" : "port_#{index}")
      hash[port_name] = port
    end
  end unless flags.ports.empty?

  args = {name: name, containers: {"app" => container}}
  manifest =
    case (type = flags.type)
    when "Deployment"
      Deployment.new(**args)
    when "StatefulSet"
      StatefulSet.new(**args)
    when "Job"
      Job.new(**args)
    when "CronJob"
      CronJob.new(schedule: "0 0 5 31 2 ?", name: name, containers: {"app" => container})
    when "DaemonSet"
      DaemonSet.new(**args)
    when "Pod"
      Pod.new(**args)
    else
      raise "Unsupported type #{type}"
    end

  # Set Docker Info
  if !flags.image
    manifest.registry_host = flags.registry_host
    manifest.registry_user = flags.registry_user || "[dockerhub username]"
  end

  # Set Registry Login Info
  if (password = flags.registry_password)
    manifest.image_pull_secrets = [
      Manifest::Shared::PullSecretCredentials.new(
        server: flags.registry_host || "https://index.docker.io/v1/",
        username: flags.registry_user || "[dockerhub username]",
        password: password
      ),
    ] of Psykube::V2::Manifest::Shared::PullSecretCredentials | String
  end

  # Set Namespace
  manifest.namespace = flags.namespace

  # Set Ingress
  if manifest.is_a? Serviceable
    manifest.ingress = V1::Manifest::Ingress.new(hosts: flags.hosts, tls: flags.tls) unless flags.hosts.empty?
  end

  manifest
end
