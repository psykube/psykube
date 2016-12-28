require "../kubernetes/pod"
require "commander"
require "./flags"
require "./push"

module Psykube::Commands
  PortForward = Commander::Command.new do |cmd|
    cmd.use = "port-forward <local> <remote>"
    cmd.short = "Exec a command in a running pod for this app."
    cmd.long = cmd.short
    cmd.flags.add Flags::Namespace
    cmd.flags.add Flags::File
    cmd.run do |options, arguments|
      namespace = options.string["namespace"]
      local = arguments[0]?
      remote = arguments[1]?

      STDERR.puts "Error: argument <local> required".colorize(:red) unless local
      STDERR.puts "Error: argument <remote> required".colorize(:red) unless remote

      pod = Helpers.get_running_pod(cmd, options)
      args = ["--namespace=#{namespace}", "port-forward", pod.name || ""]
      args << [local, remote].join(":") if local && remote
      Process.exec("kubectl", args, input: false)
    end
  end
end
