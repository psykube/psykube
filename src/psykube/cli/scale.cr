require "admiral"
require "./concerns/*"

class Psykube::Commands::Scale < Admiral::Command
  include Kubectl
  include KubectlAll

  define_help description: "Scale a deployment."

  define_argument size : UInt64, description: "Number of replicas to scale to.", required: true

  def run
    types = %w(Deployment ReplicationController ReplicaSet Job)
    types_sentence = types[0..-2].map { |t| "`#{t}`" }.join(",") + " and #{types[1]}"
    unless types.includes? generator.manifest.type
      panic "ERROR: #{flags.file} specified type `#{generator.manifest.type}`, scale can only be applied to #{types_sentence}.".colorize(:red)
    end
    if generator.manifest.replicas
      panic "ERROR: Unable to scale because replicas is set in #{flags.file}.".colorize(:red)
    end
    puts "Scaling to #{arguments.size} replicas...".colorize(:cyan)
    kubectl_run(
      "scale",
      ["#{generator.manifest.type.downcase}/#{generator.name}"],
      flags: {"--replicas" => arguments.size.to_s}
    )
  end
end
