require "admiral"
require "../psykube"
require "./ext/**"
require "./commands/*"

class Psykube::CLI::Main < Admiral::Command
  rescue_from Psykube::Error do |e|
    panic e.message.colorize(:red)
  end

  rescue_from Generator::ValidationError do |e|
    panic "Error: #{e.message}".colorize(:red)
  end

  define_flag file,
    description: "The location of the psykube manifest yml file.",
    short: f

  define_version VERSION
  define_help

  register_sub_command "apply", Commands::Apply
  register_sub_command "copy-namespace", Commands::CopyNamespace
  register_sub_command "copy-resource", Commands::CopyResource
  register_sub_command "create-namespace", Commands::CreateNamespace
  register_sub_command "delete-namespace", Commands::DeleteNamespace
  register_sub_command "generate", Commands::Generate, short: "gen"
  register_sub_command "delete", Commands::Delete, short: "rm"
  register_sub_command "exec", Commands::Exec
  register_sub_command "port-forward", Commands::PortForward
  register_sub_command "push", Commands::Push
  register_sub_command "status", Commands::Status, short: "st"
  register_sub_command "logs", Commands::Logs, short: "lg"
  register_sub_command "init", Commands::Init
  register_sub_command "history", Commands::History
  register_sub_command "rollback", Commands::Rollback
  register_sub_command "scale", Commands::Scale
  register_sub_command "run-job", Commands::RunJob, short: "j"
  register_sub_command "generate-job", Commands::GenerateJob
  register_sub_command "edit-secret", Commands::EditSecret
  register_sub_command "get-secret", Commands::GetSecret
  register_sub_command "validate", Commands::Validate
end

def Psykube::CLI.run(*args, **named_args)
  Psykube::CLI::Main.run(*args, **named_args)
end
