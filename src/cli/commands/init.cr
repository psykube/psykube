require "./concerns/*"

class Psykube::CLI::Commands::Init < Admiral::Command
  include PsykubeFileFlag

  define_help description: "Generate a .psykube.yml in the current directory."

  define_flag overwrite : Bool, "Overwrite the file if it exists.", short: 'o'
  define_flag v1 : Bool, default: false
  define_flag type, "Set the type of pyskube manifest.", short: 't', default: "Deployment"
  define_flag name, "Set the name of the application.", short: 'N'
  define_flag namespace, "Set the namespace to deploy into.", short: 'n'
  define_flag registry_host, "The hostname for the registry.", short: 'H'
  define_flag registry_user : String, "The username for the registry.", short: 'U'
  define_flag ports : Array(String), "Set a port. (can be in the format of --port 1234 or --port http=1234).", long: "port", short: "p", default: [] of String
  define_flag env : Array(String), short: "e", default: [] of String
  define_flag hosts : Array(String), "Set a host for ingress.", long: "host", default: [] of String
  define_flag tls : Bool, "Enable TLS for ingress."
  define_flag image, "Set the image, this takes precedence over --registry-host and --registry-user.", short: 'i'
  define_flag cpu_request, "Set the requested cpu resources."
  define_flag memory_request, "Set the requested memory resources."
  define_flag cpu_limit, "Set the cpu limit."
  define_flag memory_limit, "Set the memory limit."
  define_flag preview : Bool, "Don't write the file, just preview it."

  def overwrite?
    return true if flags.overwrite
    print "#{flags.file} already exists, do you want to overwrite? (y/n) "
    gets("\n").to_s.strip == "y"
  end

  def run
    manifest = flags.v1 ? Psykube::V1::Manifest.new(self) : Psykube::V2::Manifest.new(self)
    string = manifest.to_yaml
    if flags.preview
      STDOUT.write string.lines[1..-1].join("\n").to_slice
      STDOUT.puts ""
    elsif !File.exists?(flags.file) || overwrite?
      puts "Writing #{flags.file}...".colorize(:cyan)
      File.open(flags.file, "w+") do |io|
        io.write string.lines[1..-1].join("\n").to_slice
        io.puts ""
      end
    end
  end
end
