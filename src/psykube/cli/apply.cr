require "admiral"
require "./concerns/*"

class Psykube::Commands::Apply < Admiral::Command
  include Docker
  include Kubectl
  include KubectlAll

  define_help description: "Apply the kubernetes manifests."

  define_flag copy_namespace, description: "Copy from the specified namespace if this one does not exist."
  define_flag push : Bool, description: "Build and push the docker image.", default: true
  define_flag image, description: "Override the docker image."

  private def image
    generator.manifest.image || flags.image
  end

  def run
    docker_build_and_push(generator.image) if !image && flags.push
    kubectl_exec("apply", manifest: generator.result)
  end
end
