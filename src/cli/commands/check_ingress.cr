require "http"
require "./concerns/*"

class Psykube::CLI::Commands::CheckIngress < Admiral::Command
  include KubectlAll

  define_flag all : Bool,
    description: "Request all ingresses instead of just than the first."
  define_flag insecure : Bool,
    description: "Make insecure http requests instead of https."
  define_flag subpath,
    description: "The subpath to request."
  define_flag until_up : Bool,
    description: "Keep requesting until the service returns a non 504 response."

  def run
    actor.get_ingress.spec.not_nil!.rules.not_nil!.each do |rule|
      rule.not_nil!.http.not_nil!.paths.not_nil!.each do |path|
        path_string = path.path.not_nil!
        path_string += flags.subpath.to_s.lstrip('/') if flags.subpath
        uri = URI.new(
          scheme: flags.insecure ? "http" : "https",
          host: rule.host,
          path: path_string
        )
        last_status = 504
        until last_status != 504
          @output_io.print("GET #{uri} ")
          last_status = HTTP::Client.get(uri).status_code
          @output_io.puts(last_status)
          break unless flags.until_up
        end
        break unless flags.all
      end
      break unless flags.all
    end
  end
end
