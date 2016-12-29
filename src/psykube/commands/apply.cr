require "commander"
require "./flags"
require "./push"
require "./copy_namespace"

module Psykube::Commands
  Apply = Commander::Command.new do |cmd|
    cmd.use = "apply <cluster>"
    cmd.short = "Applys the kubernetes manifests."
    cmd.long = cmd.short
    cmd.flags.add Flags::Namespace
    cmd.flags.add Flags::File
    cmd.flags.add Flags::Image
    cmd.flags.add Flags::Push
    cmd.flags.add Flags::CopyNamespace
    cmd.run do |options, arguments|
      CopyNamespace.invoke([
        options.string["copy-namespace"], options.string["namespace"],
      ]) unless options.string["copy-namespace"].empty?
      Push.invoke([] of String)
      puts "Applying Kubernetes Manifests...".colorize(:cyan)
      Tempfile.open("manifests") do |file|
        file.print Helpers.build_gen(cmd, arguments, options).to_json
        file.flush
        Process.run("kubectl", ["apply", "--namespace=#{options.string["namespace"]}", "-f=#{file.path}"], output: STDOUT, error: STDERR).tap do |process|
          exit(process.exit_status) unless process.success?
        end
      end
    end
  end
end
