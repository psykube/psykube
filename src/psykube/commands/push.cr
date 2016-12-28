require "commander"
require "./flags"

module Psykube::Commands
  Push = Commander::Command.new do |cmd|
    cmd.use = "push"
    cmd.short = "Builds and pushes the docker image."
    cmd.long = cmd.short
    cmd.flags.add Flags::Tag
    cmd.flags.add Flags::File
    cmd.run do |options, arguments|
      tag = Helpers.build_tag(cmd, options)
      Process.run("docker", ["build", "-t=#{tag}", "."], output: STDERR)
      Process.exec("docker", ["push", tag])
    end
  end
end
