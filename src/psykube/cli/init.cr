require "admiral"
require "./concerns/*"

class Psykube::Commands::Init < Admiral::Command
  include PsykubeFileFlag

  define_help description: "Generate a .psykube.yml in the current directory."

  define_flag overwrite : Bool, "Overwrite the file if it exists", short: o
  define_flag name, default: File.basename(Dir.current)

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
        manifest.registry_host = nil
        manifest.registry_user = `docker info`.lines.find(&.=~ /^Username/).try(&.split(":")[1]?.to_s.strip)
        manifest.healthcheck = true
        manifest.volumes = nil
        manifest.clusters = nil
        manifest.env = nil
        manifest.secrets = nil
        manifest.config_map = nil
        manifest.ingress = nil
        manifest.clusters = {
          "default" => Manifest::Cluster.new(context: `kubectl config current-context`.strip),
        }
        manifest.to_yaml(file)
      end
    end
  end
end
