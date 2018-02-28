class Psykube::V1::Manifest
  def initialize(command : Psykube::CLI::Commands::Init)
    flags = command.flags
    @type = flags.type
    @name = flags.name || File.basename(Dir.current)

    # Set Docker Info
    if flags.image
      @image = flags.image
    else
      @registry_host = flags.registry_host
      @registry_user = flags.registry_user || Psykube.current_docker_user
    end

    # Set Resources
    @resources = Resources.from_flags(
      flags.cpu_request,
      flags.memory_request,
      flags.cpu_limit,
      flags.memory_limit
    )

    # Set Namespace
    @namespace = flags.namespace

    # Set Ports
    @ports = Hash(String, Int32).new.tap do |hash|
      flags.ports.each_with_index do |spec, index|
        parts = spec.split("=", 2).reverse
        port = parts[0].to_i? || raise "Invalid port format."
        name = parts[1]? || (index == 0 ? "default" : "port_#{index}")
        hash[name] = port
      end
    end unless flags.ports.empty?

    # Set ENV
    @env = flags.env.map(&.split('=')).each_with_object(Hash(String, Manifest::Env | String).new) do |(k, v), memo|
      memo[k] = v
    end unless flags.env.empty?

    # Set Cluster
    @clusters = {
      "default" => Cluster.new(context: Psykube.current_kubectl_context),
    }

    # Set Ingress
    @ingress = Ingress.new(hosts: flags.hosts, tls: flags.tls) unless flags.hosts.empty?
  end
end
