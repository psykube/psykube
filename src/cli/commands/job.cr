require "./concerns/*"

class Psykube::CLI::Commands::Job < Admiral::Command
  include Kubectl
  include KubectlAll

  {% if env("EXCLUDE_DOCKER") != "true" %}
  include Docker
  define_flag push : Bool, description: "Build and push the docker image.", default: true
  {% end %}
  define_flag dry_run : Bool, description: "Only show the manifest, dont apply"
  define_argument job, required: true, description: "The name of the job to run"
  define_help description: "Run the specified job."

  def run
    result = actor.generate_job(arguments.job)
    return puts result.to_yaml if flags.dry_run
    puts "Running Job #{arguments.job}...".colorize(:cyan)
    kubectl_run("apply", manifest: result)
  end
end
