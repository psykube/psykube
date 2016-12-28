require "../kubernetes/pod"
require "commander"
require "./flags"
require "./push"

module Psykube::Commands
  Exec = Commander::Command.new do |cmd|
    cmd.use = "exec <command>"
    cmd.short = "Exec a command in a running pod for this app."
    cmd.long = cmd.short
    cmd.flags.add Flags::Namespace
    cmd.flags.add Flags::File
    cmd.flags.add Flags::AllocateStdIn
    cmd.flags.add Flags::AllocateTty
    cmd.run do |options, arguments|
      namespace = options.string["namespace"]
      stdin = options.bool["stdin"]
      tty = options.bool["stdin"]
      rest_index = ARGV.index("--") || -1
      rest = rest_index >= 0 ? ARGV[rest_index + 1..-1] : [] of String

      if arguments.empty? && rest.empty?
        puts "Error: argument <command> required".colorize(:red)
        exit 2
      end

      pod = Helpers.get_running_pod(cmd, options)
      args = ["--namespace=#{namespace}", "exec", pod.name || ""]
      args << "-i" if stdin
      args << "-t" if tty
      args.concat(arguments + rest)
      Process.exec("kubectl", args, input: stdin ? STDIN : false, error: STDERR, output: STDOUT)
    end
  end
end
