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
    secret_name = flags.secret_name || actor.name
    secret = Pyrite::Api::Core::V1::Secret.from_json(kubectl_json(resource: "secret", name: secret_name))
    if (value = secret.data.try(&.[arguments.name]?))
      @output_io.puts Base64.decode_string(value)
    else
      panic "No key named `#{arguments.name}` in secret `#{secret_name}`"
    end
  end
end
