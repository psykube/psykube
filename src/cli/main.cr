require "admiral"
require "../psykube"
require "./ext/**"
require "./commands/*"

class Psykube::CLI::Main < Admiral::Command
  rescue_from Psykube::Error do |e|
    panic e.message
  end

  rescue_from Generator::ValidationError do |e|
    panic "Error: #{e.message}".colorize(:red)
  end

  define_version VERSION
  define_help

  register_sub_command "apply", Commands::Apply, short: "a"
  register_sub_command "copy-namespace", Commands::CopyNamespace
  register_sub_command "copy-resource", Commands::CopyResource
  register_sub_command "create-namespace", Commands::CreateNamespace
  register_sub_command "delete-namespace", Commands::DeleteNamespace
  register_sub_command "generate", Commands::Generate, short: "g"
  register_sub_command "delete", Commands::Delete, short: "d"
  register_sub_command "exec", Commands::Exec, short: "e"
  register_sub_command "port-forward", Commands::PortForward, short: "pf"
  register_sub_command "push", Commands::Push, short: "p"
  register_sub_command "status", Commands::Status, short: "s"
  register_sub_command "logs", Commands::Logs, short: "l"
  register_sub_command "init", Commands::Init, short: "i"
  register_sub_command "history", Commands::History, short: "h"
  register_sub_command "rollback", Commands::Rollback, short: "rb"
  register_sub_command "scale", Commands::Scale
  register_sub_command "run-job", Commands::RunJob
  register_sub_command "generate-job", Commands::GenerateJob
  register_sub_command "validate", Commands::Validate, short: "v"
end

def Psykube::CLI.run(*args, **named_args)
  Psykube::CLI::Main.run(*args, **named_args)
end
