require "./concerns/*"

class Psykube::CLI::Commands::GenerateJob < Admiral::Command
  include PsykubeFileFlag
  include KubectlClusterArg
  include KubectlNamespaceFlag
  include Kubectl

  define_help description: "Generate the kubernetes manifests for a job."
  define_flag output, description: "Write the raw kubernetes files to a folder.", short: o
  define_argument job_name, description: "the name of the job you wish to generate."
  define_flag current_image : Bool, description: "Use the currently deployed image."

  def run
    set_images_from_current! if flags.current_image
    manifest = actor.get_job(arguments.job_name)
    if (output = flags.output)
      output_dir = File.expand_path(output)
      manifest.items.not_nil!.each do |item|
        kind = item.kind.downcase
        name = item.metadata.not_nil!.name.to_s
        FileUtils.mkdir_p(output_dir)
        filename = File.join(output_dir, "#{name}.#{kind}.yaml")
        File.open(filename, "w+") do |io|
          item.to_yaml(io)
        end
      end
    else
      manifest.to_yaml(@output_io)
    end
  end
end
