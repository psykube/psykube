require "commander"
require "colorize"
require "../kubernetes/pod"
require "./flags"
require "./push"

module Psykube::Commands
  class LabeledIO
    include IO
    Colors = %i(
      red
      green
      yellow
      blue
      magenta
      cyan
      light_red
      light_green
      light_yellow
      light_blue
      light_magenta
      light_cyan
    )
    @color : Symbol

    delegate read, to: @io

    def initialize(@io : IO, @label : String?, color = nil)
      @color = color || Colors.sample
    end

    def write(slice : Bytes)
      String.new(slice).strip.split("\n").each do |string|
        @io.puts ["[#{@label}]".colorize(@color), string].join(" ")
      end
    end
  end

  Logs = Commander::Command.new do |cmd|
    cmd.use = "logs"
    cmd.short = "Logs for this application"
    cmd.long = cmd.short
    cmd.flags.add Flags::Namespace
    cmd.flags.add Flags::File
    cmd.run do |options, arguments|
      namespace = options.string["namespace"]
      pods = Helpers.get_pods(cmd, options, phase: nil)
      pods.map do |pod|
        io = LabeledIO.new(STDOUT, label: pod.name)
        args = ["--namespace=#{namespace}", "logs", pod.name || "", "-f", "--tail=1"]
        Process.new(ENV["KUBECTL_BIN"], args, input: false, error: STDERR, output: io)
      end.each(&.wait)
    end
  end
end
