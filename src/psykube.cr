require "tempfile"
require "commander"
require "colorize"
require "./psykube/commands/*"

ENV["KUBECTL_BIN"] ||= `which kubectl`.strip
ENV["DOCKER_BIN"] ||= `which docker`.strip

cli = Commander::Command.new do |cmd|
  cmd.use = "psykube"
  cmd.long = "A tool for managing the Kubernetes lifecycle of a single container application."

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

begin
  Commander.run(cli, ARGV[0..(ARGV.index("--") || -1)])
rescue e
  STDERR.puts "Error: #{e.message}".colorize(:red)
  exit(2)
end
