require "admiral"
require "./concerns/*"

def current_docker_user
  `#{Psykube::Commands::Docker.bin} info`.lines.find(&.=~ /^Username/).try(&.split(":")[1]?).to_s.strip
end

class Psykube::Commands::Init < Admiral::Command
  include PsykubeFileFlag

  define_help description: "Generate a .psykube.yml in the current directory."

  define_flag overwrite : Bool, "Overwrite the file if it exists", short: o
  define_flag name, default: File.basename(Dir.current)
  define_flag registry_host
  define_flag registry_user : String, default: current_docker_user
  define_flag image

  def overwrite?
    return true if flags.overwrite
    puts "#{flags.file} already exists, do you want to overwrite? (y/n) "
    gets("\n").to_s.strip == "y"
  end

  def run
    if !File.exists?(flags.file) || overwrite?
      puts "Writing #{flags.file}...".colorize(:cyan)
      File.open(flags.file, "w+") do |file|
        manifest = Psykube::Manifest.from_yaml({{ `cat "reference/.psykube.yml"`.stringify }})
        manifest.name = flags.name
        if ingress = manifest.ingress
          ingress.annotations = nil
          ingress.hosts = nil
        end
        manifest.image = flags.image
        manifest.registry_host = flags.registry_host
        manifest.registry_user = flags.registry_user
        manifest.healthcheck = true
        manifest.volumes = nil
        manifest.clusters = nil
        manifest.env = nil
        manifest.secrets = nil
        manifest.config_map = nil
        manifest.ingress = nil
        manifest.clusters = {
          "default" => Manifest::Cluster.new(context: `#{Kubectl.bin} config current-context`.strip),
        }
        manifest.to_yaml(file)
      end
    end
  end
end
