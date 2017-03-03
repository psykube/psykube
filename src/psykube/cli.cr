require "admiral"
require "./cli/*"
require "./namespace_cleaner"

class Psykube::CLI < Admiral::Command
  {{ run "#{__DIR__}/parse_version.cr" }}

  define_version VERSION
  define_help

  register_sub_command apply, Commands::Apply
  register_sub_command "copy-namespace", Commands::CopyNamespace
  register_sub_command "copy-resource", Commands::CopyResource
  register_sub_command generate, Commands::Generate
  register_sub_command delete, Commands::Delete
  register_sub_command exec, Commands::Exec
  register_sub_command "port-forward", Commands::PortForward
  register_sub_command push, Commands::Push
  register_sub_command status, Commands::Status
  register_sub_command logs, Commands::Logs
  register_sub_command init, Commands::Init
  register_sub_command history, Commands::History
  register_sub_command rollback, Commands::Rollback
  register_sub_command scale, Commands::Scale
  register_sub_command playground, Commands::Playground
end
