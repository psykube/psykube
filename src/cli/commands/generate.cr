require "./concerns/*"

class Psykube::CLI::Commands::Generate < Admiral::Command
  include PsykubeFileFlag
  include KubectlClusterArg
  include KubectlNamespaceFlag

  define_help description: "Generate the kubernetes manifests."
  define_flag image, description: "Override the docker image."
  define_flag tag, description: "The docker tag to apply.", short: t
  define_flag pretty : Bool, description: "Prettyify the output", default: true

  def run
    actor.to_yaml(@output_io)
  end
end
