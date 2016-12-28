require "commander"
require "./flags"
require "./push"

module Psykube::Commands
  Apply = Commander::Command.new do |cmd|
    cmd.use = "apply <cluster>"
    cmd.short = "Applys the kubernetes manifests"
    cmd.long = cmd.short
    cmd.flags.add Flags::Namespace
    cmd.flags.add Flags::File
    cmd.flags.add Flags::Image
    cmd.flags.add Flags::Push
    cmd.run do |options, arguments|
      puts "Applying Kubernetes Manifests..."
      Push.invoke([] of String)
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
