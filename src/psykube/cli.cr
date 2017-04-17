require "admiral"
require "./parse_exception"
require "./cli/*"
require "./name_cleaner"

class Psykube::CLI < Admiral::Command
  {{ run "#{__DIR__}/parse_version.cr" }}

  rescue_from Psykube::ParseException do |e|
    panic e.message
  end

  rescue_from Generator::ValidationError do |e|
    panic "Error: #{e.message}".colorize(:red)
  end

  define_version VERSION
  define_help

  register_sub_command apply, Commands::Apply
  register_sub_command "copy-namespace", Commands::CopyNamespace
  register_sub_command "copy-resource", Commands::CopyResource
  register_sub_command generate, Commands::Generate
  register_sub_command delete, Commands::Delete
  register_sub_command exec, Commands::Exec
  register_sub_command "port-forward", Commands::PortForward
  {% if env("EXCLUDE_DOCKER") != "true" %}
  register_sub_command push, Commands::Push
  {% end %}
  register_sub_command status, Commands::Status
  register_sub_command logs, Commands::Logs
  register_sub_command init, Commands::Init
  register_sub_command history, Commands::History
  register_sub_command rollback, Commands::Rollback
  register_sub_command scale, Commands::Scale
  register_sub_command playground, Commands::Playground
  register_sub_command validate, Commands::Validate
end
