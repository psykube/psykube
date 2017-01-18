require "commander"

require "commander"
require "./flags"

module Psykube::Commands
  Init = Commander::Command.new do |cmd|
    cmd.use = "init"
    cmd.short = "Creates a .psykube.yml file for the current application."
    cmd.long = cmd.short
    cmd.run do |options, arguments|
      File.open(".psykube.yml", "w+") do |file|
        manifest = Psykube::Manifest.from_yaml({{ `cat "reference/.psykube.yml"`.stringify }})
        manifest.name = File.basename Dir.current
        # manifest.env = {
        #   "KEY" => "value",
        # }
        if ingress = manifest.ingress
          ingress.annotations = nil
          ingress.hosts = nil
        end
        manifest.registry_host = nil
        manifest.healthcheck = true
        manifest.volumes = nil
        manifest.clusters = nil
        manifest.to_yaml(file)
      end
    end
  end
end
