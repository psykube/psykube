require "commander"
require "./flags"
require "../kubernetes/list"

module Psykube::Commands
  CopyNamespace = Commander::Command.new do |cmd|
    cmd.use = "copy-namespace <from> <to>"
    cmd.short = "Copys a kubernetes namespace"
    cmd.long = cmd.short
    cmd.flags.add Flags::Resources
    cmd.run do |options, arguments|
      resources = options.string["resources"]
      STDERR.puts "Error: Argument <from> required!" unless from = arguments[0]?
      STDERR.puts "Error: Argument <to> required!" unless to = arguments[1]?

      exit(1) unless from && to

      puts "Copying Namespace: `#{from}` to `#{to}` (resources: #{resources.split(",").join(", ")})..."
      io = IO::Memory.new
      # io = STDERR
      Process.run("kubectl", ["get", resources, "-o=json"], output: io, error: STDERR).tap do |process|
        exit(process.exit_status) unless process.success?
      end
      io.rewind
      list = Kubernetes::List.from_json(io)
      puts list.to_yaml

      # tag = Helpers.build_tag(cmd, options)
      # Process.run("docker", ["build", "-t=#{tag}", "."], output: STDOUT, error: STDERR).tap do |process|
      #   exit(process.exit_status) unless process.success?
      # end
      # puts "Pushing to Docker Registry..."
      # Process.run("docker", ["push", tag], output: STDOUT, error: STDERR).tap do |process|
      #   exit(process.exit_status) unless process.success?
      # end
    end
  end
end
