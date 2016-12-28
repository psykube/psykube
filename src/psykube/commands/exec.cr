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

      if arguments.empty?
        puts "Error: argument <command> required".colorize(:red)
      end

      # Kubernetes::Pod.from_json(File.read("test.json"))
      # exit

      io = IO::Memory.new
      selector_labels = Helpers.build_selector_labels(cmd, options)
      Process.run("kubectl", ["--namespace=#{namespace}", "get", "pods", "--selector=#{selector_labels}", "-o=json"], output: io, error: STDERR).tap do |process|
        exit(process.exit_status) unless process.success?
      end
      io.rewind
      pod_list = Kubernetes::List.from_json(io)
      pod = pod_list.find do |pod|
        if pod.is_a?(Kubernetes::Pod)
          (pod.status || Kubernetes::Pod::Status.new).phase == "Running"
        end
      end

      # Exec into the pod
      if pod.is_a? Kubernetes::Pod
        args = ["--namespace=#{namespace}", "exec", pod.name || ""]
        args << "-i" if stdin
        args << "-t" if tty
        args.concat(arguments)
        Process.exec("kubectl", args)
      else
        STDERR.puts "Error: There are no running pods, try running `psykube status`"
        exit 2
      end
    end
  end
end
