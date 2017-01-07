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
    cmd.flags.add Flags::BuildArgs
    cmd.run do |options, arguments|
      CopyNamespace.invoke([
        options.string["copy-namespace"], options.string["namespace"],
      ]) unless options.string["copy-namespace"].empty?
      if options.bool["push"] || !options.bool["image"]
        push_args = ["--file=#{options.string["file"]}"]
        push_args << "--build-args=#{options.string["build-args"]}" unless options.string["build-args"].empty?
        Push.invoke(push_args)
      end
      puts "Applying Kubernetes Manifests...".colorize(:cyan)
      Tempfile.open("manifests") do |file|
        file.print Helpers.build_gen(cmd, arguments, options).to_json
        file.flush
        Process.exec(ENV["KUBECTL_BIN"], ["apply", "--namespace=#{options.string["namespace"]}", "-f=#{file.path}"])
      end
    end
  end
end
