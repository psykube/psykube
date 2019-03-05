require "./concerns/*"

class Psykube::CLI::Commands::EditSecret < Admiral::Command
  include KubectlAll
  include Kubectl

  define_help description: "Edit a secrets plain text values"

  define_argument name, description: "The name of the secret."

  def run
    secret = Pyrite::Api::Core::V1::Secret.from_json(kubectl_json(resource: "secret", name: arguments.name || actor.name))
    data = decode(secret.data || {} of String => String)
    tempfile =
      {% if compare_versions(Crystal::VERSION, "0.27.0") < 0 %}
        Tempfile.open("edit-secret") do |io|
          data.to_yaml(io)
        end
      {% else %}
        File.tempfile do |io|
          data.to_yaml(io)
        end
      {% end %}
    Process.run(command: ENV["EDITOR"] || "vim", args: [tempfile.path], input: STDIN, output: STDOUT, error: STDERR)
    secret.data = encode(Hash(String, String).from_yaml(File.read(tempfile.path)))
    kubectl_run("apply", manifest: secret)
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
      o[k] = Base64.encode(v)
    end
  end
end
