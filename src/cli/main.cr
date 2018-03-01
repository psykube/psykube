require "admiral"
require "../psykube"
require "./ext/**"
require "./commands/*"

class Psykube::CLI::Main < Admiral::Command
  rescue_from Psykube::ParseException do |e|
    panic e.message
  end

  rescue_from Generator::ValidationError do |e|
    panic "Error: #{e.message}".colorize(:red)
  end

  define_version VERSION
  define_help

  register_sub_command apply, Commands::Apply, short: a
  register_sub_command "copy-namespace", Commands::CopyNamespace
  register_sub_command "copy-resource", Commands::CopyResource
  register_sub_command generate, Commands::Generate, short: g
  register_sub_command delete, Commands::Delete, short: d
  register_sub_command exec, Commands::Exec, short: e
  register_sub_command "port-forward", Commands::PortForward, short: pf
  {% if env("EXCLUDE_DOCKER") != "true" %}
  register_sub_command push, Commands::Push, short: p
  {% end %}
  register_sub_command status, Commands::Status, short: s
  register_sub_command logs, Commands::Logs, short: l
  register_sub_command init, Commands::Init
  register_sub_command history, Commands::History
  register_sub_command rollback, Commands::Rollback
  register_sub_command scale, Commands::Scale
  register_sub_command playground, Commands::Playground
  register_sub_command validate, Commands::Validate, short: v
end

def Psykube::CLI.run(*args, **named_args)
  Psykube::CLI::Main.run(*args, **named_args)
end
