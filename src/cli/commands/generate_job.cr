require "./concerns/*"

class Psykube::CLI::Commands::GenerateJob < Admiral::Command
  include PsykubeFileFlag
  include KubectlClusterArg
  include KubectlNamespaceFlag
  include Kubectl

  define_help description: "Generate the kubernetes manifests for a job."
  define_flag output, description: "Write the raw kubernetes files to a folder.", short: o
  define_argument job_name, description: "the name of the job you wish to generate."

  def run
    set_images_from_current!
    job = actor.get_job(arguments.job_name)
    if (output = flags.output)
      output_dir = File.expand_path(output)
      kind = job.kind.downcase
      name = job.metadata.not_nil!.name.to_s
      FileUtils.mkdir_p(output_dir)
      filename = File.join(output_dir, "#{name}.#{kind}.yaml")
      File.open(filename, "w+") do |io|
        actor.get_job(arguments.job_name).to_yaml(io)
      end
    else
      job.to_yaml(@output_io)
    end
  end
end
