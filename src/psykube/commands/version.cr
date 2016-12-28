require "commander"
require "./flags"
require "./push"
require "../version"

module Psykube::Commands
  Version = Commander::Command.new do |cmd|
    cmd.use = "version"
    cmd.short = "Prints the psykube version"
    cmd.long = cmd.short
    cmd.run do |options, arguments|
      puts Psykube::Version.version
    end
  end
end
