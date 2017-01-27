require "admiral"
require "./cli/*"

class Psykube::CLI < Admiral::Command
  VERSION = {{ env("TRAVIS_TAG") || "git-#{`git rev-parse --short HEAD`}" }}

  define_version VERSION
  define_help

  register_sub_command apply, Commands::Apply, description: "Apply the kubernetes manifests."
  register_sub_command "copy-namespace", Commands::CopyNamespace, description: "Copy one namespace to another."
  register_sub_command generate, Commands::Generate, description: "Generate the kubernetes manifests."
  register_sub_command delete, Commands::Delete, description: "Delete the kubernetes manifests."
  register_sub_command exec, Commands::Exec, description: "Exec a command in a running container."
  register_sub_command "port-forward", Commands::PortForward, description: "Forward a port from a running container to the local machine."
  register_sub_command push, Commands::Push, description: "Build and push the docker image."
  register_sub_command status, Commands::Status, description: "List the status of the kubernetes resources."
  register_sub_command logs, Commands::Logs, description: "Follow the logs of running pods."
  register_sub_command init, Commands::Init, description: "Generate a .psykube.yml in the current directory."

  def run
    puts help
    exit 1
  end
end
