require "commander"
require "./flags"

module Psykube::Commands
  Apply = Commander::Command.new do |cmd|
    cmd.use = "apply <cluster>"
    cmd.short = "Applys the kubernetes manifests"
    cmd.long = cmd.short
    cmd.flags.add Flags::Namespace
    cmd.flags.add Flags::File
    cmd.flags.add Flags::Image
    cmd.run do |options, arguments|
      Tempfile.open("manifests") do |file|
        gen = Helpers.build_gen(cmd, arguments, options).to_json
        file.flush
        Process.exec("kubectl", ["apply", "--namespace=#{options.string["namespace"]}", "-f=#{file.path}"])
      end
    end
  end
end
