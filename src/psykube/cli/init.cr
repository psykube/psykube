require "admiral"
require "./concerns/*"

def current_docker_user
  `#{Psykube::Commands::Docker.bin} info`.lines.find(&.=~ /^Username/).try(&.split(":")[1]?).to_s.strip
end

class Psykube::Commands::Init < Admiral::Command
  include PsykubeFileFlag

  define_help description: "Generate a .psykube.yml in the current directory."

  define_flag overwrite : Bool, "Overwrite the file if it exists", short: 'o'
  define_flag name, "Set the name of the application.", short: 'N'
  define_flag namespace, "Set the namespace to deploy into.", short: 'n'
  define_flag registry_host, "The hostname for the registry.", short: 'H'
  define_flag registry_user : String, "The username for the registry.", short: 'U'
  define_flag ports : Array(String), "Set a port. (can be in the format of --port 1234 or --port http=1234).", long: "port", short: "p", default: [] of String
  define_flag env : Array(String), short: "e", default: [] of String
  define_flag hosts : Array(String), "Set a host for ingress.", long: "host", default: [] of String
  define_flag tls : Bool, "Enable TLS for ingress.", short: 't'
  define_flag image, "Set the image, this takes precedence over --registry-host and --registry-user.", short: 'i'
  define_flag cpu_request, "Set the requested cpu resources."
  define_flag memory_request, "Set the requested memory resources."
  define_flag cpu_limit, "Set the cpu limit."
  define_flag memory_limit, "Set the memory limit."

  def overwrite?
    return true if flags.overwrite
    print "#{flags.file} already exists, do you want to overwrite? (y/n) "
    gets("\n").to_s.strip == "y"
  end

  def run
    if !File.exists?(flags.file) || overwrite?
      puts "Writing #{flags.file}...".colorize(:cyan)
      File.open(flags.file, "w+") do |file|
        manifest = Psykube::Manifest.new(flags.name || File.basename(Dir.current))
        if ingress = manifest.ingress
          ingress.annotations = nil
          ingress.hosts = nil
        end
        if flags.image
          manifest.image = flags.image
        else
          manifest.registry_host = flags.registry_host
          manifest.registry_user = flags.registry_user || current_docker_user
        end
        manifest.resources = Manifest::Resources.new(
          flags.cpu_request,
          flags.memory_request,
          flags.cpu_limit,
          flags.memory_limit
        )
        manifest.namespace = flags.namespace
        manifest.ports = Hash(String, UInt16).new.tap do |hash|
          flags.ports.each_with_index do |spec, index|
            parts = spec.split("=", 2).reverse
            port = parts[0].to_u16? || raise "Invalid port format."
            name = parts[1]? || (index == 0 ? "default" : "port_#{index}")
            hash[name] = port
          end
        end unless flags.ports.empty?
        manifest.env = flags.env.map(&.split('=')).each_with_object(Hash(String, Manifest::Env | String).new) do |(k, v), memo|
          memo[k] = v
        end unless flags.env.empty?
        manifest.clusters = {
          "default" => Manifest::Cluster.new(context: `#{Kubectl.bin} config current-context`.strip),
        }
        manifest.ingress = Manifest::Ingress.new(hosts: flags.hosts, tls: flags.tls) unless flags.hosts.empty?
        string = manifest.to_yaml
        file.write string.lines[1..-1].join("\n").to_slice
      end
    end
  end
end
