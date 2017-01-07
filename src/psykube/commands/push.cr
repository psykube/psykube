require "commander"
require "./flags"

module Psykube::Commands
  Push = Commander::Command.new do |cmd|
    cmd.use = "push"
    cmd.short = "Builds and pushes the docker image."
    cmd.long = cmd.short
    cmd.flags.add Flags::Tag
    cmd.flags.add Flags::File
    cmd.flags.add Flags::BuildArgs
    cmd.run do |options, arguments|
      puts "Building Docker Container...".colorize(:cyan)

      tag = Helpers.build_tag(cmd, options)
      args = ["build", "-t=#{tag}", "."]
      Helpers.add_build_args(args, options)

      Process.run(ENV["DOCKER_BIN"], args, output: STDOUT, error: STDERR).tap do |process|
        exit(process.exit_status) unless process.success?
      end
      puts "Pushing to Docker Registry...".colorize(:cyan)
      Process.run(ENV["DOCKER_BIN"], ["push", tag], output: STDOUT, error: STDERR).tap do |process|
        exit(process.exit_status) unless process.success?
      end
    end
  end
end
