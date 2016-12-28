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
      puts "Building Docker Container...".colorize(:cyan)
      tag = Helpers.build_tag(cmd, options)
      Process.run("docker", ["build", "-t=#{tag}", "."], output: STDOUT, error: STDERR).tap do |process|
        exit(process.exit_status) unless process.success?
      end
      puts "Pushing to Docker Registry..."
      Process.run("docker", ["push", tag], output: STDOUT, error: STDERR).tap do |process|
        exit(process.exit_status) unless process.success?
      end
    end
  end
end
