require "commander"
require "./flags"

module Psykube::Commands
  Generate = Commander::Command.new do |cmd|
    cmd.use = "generate <cluster>"
    cmd.short = "Generates the kubernetes manifests."
    cmd.long = cmd.short
    cmd.flags.add Flags::Namespace
    cmd.flags.add Flags::File
    cmd.flags.add Flags::Image
    cmd.run do |options, arguments|
      gen = Helpers.build_gen(cmd, arguments, options)
      puts gen.to_json
    end
  end
end
