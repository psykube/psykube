require "commander"
require "./flags"
require "../kubernetes/list"

module Psykube::Commands
  CopyNamespace = Commander::Command.new do |cmd|
    cmd.use = "copy-namespace <from> <to>"
    cmd.short = "Copys a kubernetes namespace."
    cmd.long = cmd.short
    cmd.flags.add Flags::Resources
    cmd.run do |options, arguments|
      resources = options.string["resources"]
      STDERR.puts "Error: Argument <from> required!" unless from = arguments[0]?
      STDERR.puts "Error: Argument <to> required!" unless to = arguments[1]?

      raise ArgumentError.new("Missing required arguments!") unless from && to

      puts "Copying Namespace: `#{from}` to `#{to}` (resources: #{resources.split(",").join(", ")})...".colorize(:cyan)
      io = IO::Memory.new
      Process.run(ENV["KUBECTL_BIN"], ["--export", "--namespace=#{from}", "get", resources, "-o=json"], output: io, error: STDERR).tap do |process|
        exit(process.exit_status) unless process.success?
      end
      io.rewind

      # Build the list of existing resources
      list = Kubernetes::List.from_json(io)

      # Get or build the namespace
      io = IO::Memory.new
      Process.run(ENV["KUBECTL_BIN"], ["get", "namespace", to, "--export", "-o=json"], output: io)
      namespace = Kubernetes::Namespace.from_json(io) rescue Kubernetes::Namespace.new(to)
      list.unshift namespace

      # Clean the list
      list.clean!

      Tempfile.open("manifests") do |file|
        file.print list.to_json
        file.flush
        Process.run(ENV["KUBECTL_BIN"], ["apply", "--namespace=#{to}", "-f=#{file.path}"], output: STDOUT, error: STDERR).tap do |process|
          exit(process.exit_status) unless process.success?
        end
      end
    end
  end
end
