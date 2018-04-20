require "./concerns/*"

class Psykube::CLI::Commands::Generate < Admiral::Command
  include PsykubeFileFlag
  include KubectlClusterArg
  include KubectlNamespaceFlag

  define_help description: "Generate the kubernetes manifests."
  define_flag image, description: "Override the docker image."
  define_flag output, description: "Write the raw kubernetes files to a folder.", short: o
  define_flag tag, description: "The docker tag to apply.", short: t

  def run
    if (output = flags.output)
      list_manifest = actor.generate
      Dir.cd(output) do
        list_manifest.items.not_nil!.each do |item|
          kind = item.kind.downcase
          name = item.metadata.not_nil!.name.to_s
          File.open("#{name}.#{kind}.yaml", "w+") do |io|
            item.to_yaml(io)
          end
        end
      end
    else
      actor.to_yaml(@output_io)
    end
  end
end
