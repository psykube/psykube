require "./concerns/*"

class Psykube::CLI::Commands::RunJob < Admiral::Command
  include Kubectl
  include KubectlAll
  include Docker
  include Kubectl

  define_flag build : Bool, description: "Don't build the docker image.", default: true
  define_flag push : Bool, description: "Don't push the docker image.", default: true
  define_flag create_namespace : Bool, description: "create the namespace before the given apply."
  define_flag skip_if_no_cluster : Bool, description: "dont fail, just skip the apply if the cluster does not exist."
  define_argument job_name, description: "the name of the job you wish to run."

  define_help description: "Run a named job."

  def run
    if (actor.clusters.empty? || !actor.cluster.initialized?)
      kubectl_create_namespace(namespace) if flags.create_namespace

      # Build the image
      if flags.build
        docker_build(actor.buildable_contexts)
      else
        set_images_from_current!
      end

      result = actor.get_job(arguments.job_name)
      puts "Applying Kubernetes Manifests...".colorize(:cyan)
      result.items.not_nil!.each do |item|
        kubectl_run("apply", manifest: item)
      end
    elsif flags.skip_if_no_cluster
      @error_io.puts "cluster not defined: `#{actor.cluster_name}`, skipping...".colorize(:yellow)
    else
      raise Error.new "cluster not defined: `#{actor.cluster_name}`"
    end
  end
end
