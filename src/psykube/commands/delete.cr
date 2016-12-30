require "commander"
require "./flags"
require "./push"

module Psykube::Commands
  Delete = Commander::Command.new do |cmd|
    cmd.use = "delete <cluster>"
    cmd.short = "Deletes the kubernetes manifests."
    cmd.long = cmd.short
    cmd.flags.add Flags::Namespace
    cmd.flags.add Flags::File
    cmd.flags.add Flags::Image
    cmd.flags.add Flags::Push
    cmd.run do |options, arguments|
      puts "Deleting Kubernetes Manifests...".colorize(:yellow)
      Tempfile.open("manifests") do |file|
        file.print Helpers.build_gen(cmd, arguments, options).to_json
        file.flush
        Process.exec("kubectl", ["delete", "--namespace=#{options.string["namespace"]}", "-f=#{file.path}"])
      end
    end
  end
end
