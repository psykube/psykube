require "./concerns/*"

class Psykube::CLI::Commands::GetSecret < Admiral::Command
  include KubectlAll
  include Kubectl

  define_help description: "Get the plain text value of a secret."

  define_flag secret_name,
    description: "The name of the secret to get the field from."

  define_argument name,
    description: "The command to run in the container."

  def run
    secret = Pyrite::Api::Core::V1::Secret.from_json(kubectl_json(resource: "secret", name: flags.secret_name || actor.name))
    data = decode(secret.data || {} of String => String)
    @output_io.puts data[arguments.name]
  end

  private def decode(data : Hash(String, String))
    data.each_with_object({} of String => String) do |(k, v), o|
      o[k] = Base64.decode_string(v)
    end
  end
end
