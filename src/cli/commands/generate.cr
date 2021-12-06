require "./concerns/*"

class Psykube::CLI::Commands::Generate < Admiral::Command
  include PsykubeFileFlag
  include KubectlClusterArg
  include KubectlNamespaceFlag
  include Kubectl

  define_help description: "Generate the kubernetes manifests."
  define_flag image, description: "Override the docker image."
  define_flag output, description: "Write the raw kubernetes files to a folder.", short: o
  define_flag tag, description: "The docker tag to apply.", short: t
  define_flag current_image : Bool, description: "Use the currently deployed image."

  def run
    set_images_from_current! if flags.current_image
    if (output = flags.output)
      output_dir = File.expand_path(output)
      actor.generate.items.not_nil!.each do |item|
        kind = item.kind.downcase
        if item.is_a?(Pyrite::Kubernetes::ObjectMetadata)
          name = item.metadata.not_nil!.name.to_s
        end
        FileUtils.mkdir_p(output_dir)
        filename = File.join(output_dir, "#{name}.#{kind}.yaml")
        File.open(filename, "w+") do |io|
          item.to_yaml(io)
        end
      end
    else
      actor.to_yaml(@output_io)
    end
  end
end
