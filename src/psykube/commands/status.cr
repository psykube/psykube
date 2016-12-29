require "commander"
require "./flags"
require "./push"

module Psykube::Commands
  Status = Commander::Command.new do |cmd|
    cmd.use = "status"
    cmd.short = "Status of the pods belonging to this app."
    cmd.long = cmd.short
    cmd.flags.add Flags::Namespace
    cmd.flags.add Flags::File
    cmd.run do |options, arguments|
      namespace = options.string["namespace"]
      selector_labels = Helpers.build_selector_labels(cmd, options)
      puts "Pod status ============================="
      Process.exec("kubectl", ["--namespace=#{namespace}", "get", "pods", "--selector=#{selector_labels}"])
    end
  end
end
