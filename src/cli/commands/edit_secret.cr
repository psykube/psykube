require "./concerns/*"

class Psykube::CLI::Commands::EditSecret < Admiral::Command
  include KubectlAll
  include Kubectl

  define_help description: "Edit a secrets plain text values"

  define_argument name, description: "The name of the secret."
  define_flag dry_run : Bool, description: "Display the change without writing it to the cluster."

  def run
    json = kubectl_json(resource: "secret", name: arguments.name || actor.name)
    secret = Pyrite::Api::Core::V1::Secret.from_json(json)
    data = decode(secret.data || {} of String => String)
    tempfile = File.tempfile do |io|
      data.to_yaml(io)
    end
    Process.run(command: ENV["EDITOR"] || "vim", args: [tempfile.path], input: @input_io, output: @output_io, error: @error_io)
    secret.data = encode(Hash(String, String).from_yaml(File.read(tempfile.path)))
    flags.dry_run ? puts(secret.to_yaml) : kubectl_run("apply", manifest: secret)
  ensure
    tempfile.delete if tempfile
  end

  private def decode(data : Hash(String, String))
    data.each_with_object({} of String => String) do |(k, v), o|
      o[k] = Base64.decode_string(v)
    end
  end

  private def encode(data : Hash(String, String))
    data.each_with_object({} of String => String) do |(k, v), o|
      o[k] = Base64.strict_encode(v).strip
    end
  end
end
