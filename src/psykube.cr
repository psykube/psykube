require "tempfile"
require "commander"
require "./psykube/commands/*"

cli = Commander::Command.new do |cmd|
  cmd.use = "psykube"
  cmd.long = "A tool for interacting and deploying to kubernetes clusters within CI/CD environments."

  cmd.run do |options, arguments|
    puts cmd.help
  end

  cmd.commands.add Psykube::Commands::Generate
  cmd.commands.add Psykube::Commands::Apply
  cmd.commands.add Psykube::Commands::Push
  cmd.commands.add Psykube::Commands::CopyNamespace
  cmd.commands.add Psykube::Commands::Exec
  cmd.commands.add Psykube::Commands::PortForward
  cmd.commands.add Psykube::Commands::Delete
  cmd.commands.add Psykube::Commands::Status
  cmd.commands.add Psykube::Commands::Version
end

Commander.run(cli, ARGV[0..(ARGV.index("--") || -1)])
