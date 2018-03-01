require "./concerns/*"

class Psykube::CLI::Commands::Scale < Admiral::Command
  include Kubectl
  include KubectlAll

  define_help description: "Scale a deployment."

  define_argument size : Int32, description: "Number of replicas to scale to.", required: true

  def run
    manifest = actor.manifest
    types = %w(Deployment ReplicationController ReplicaSet Job)
    types_sentence = types[0..-2].map { |t| "`#{t}`" }.join(",") + " and #{types[1]}"
    unless types.includes? manifest.type
      panic "ERROR: #{flags.file} specified type `#{actor.manifest.type}`, scale can only be applied to #{types_sentence}.".colorize(:red)
    end
    if manifest.responds_to?(:replicas) && manifest.replicas
      panic "ERROR: Unable to scale because replicas is set in #{flags.file}.".colorize(:red)
    end
    puts "Scaling to #{arguments.size} replicas...".colorize(:cyan)
    kubectl_run(
      "scale",
      ["#{actor.manifest.type.to_s.downcase}/#{actor.name}"],
      flags: {"--replicas" => arguments.size.to_s}
    )
  end
end
