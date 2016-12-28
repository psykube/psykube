require "commander"

module Psykube::Commands::Flags
  Namespace = Commander::Flag.new do |flag|
    flag.name = "namespace"
    flag.short = "-n"
    flag.long = "--namespace"
    flag.default = "default"
    flag.description = "The namespace to deploy in"
  end

  Image = Commander::Flag.new do |flag|
    flag.name = "image"
    flag.short = "-i"
    flag.long = "--image"
    flag.default = ""
    flag.description = "The image to deploy"
  end

  Verbose = Commander::Flag.new do |flag|
    flag.name = "verbose"
    flag.short = "-v"
    flag.long = "--verbose"
    flag.default = false
    flag.description = "Enable more verbose logging."
  end

  File = Commander::Flag.new do |flag|
    flag.name = "file"
    flag.short = "-f"
    flag.long = "--file"
    flag.default = "./.psykube.yml"
    flag.description = "The psykube file to use"
  end

  Tag = Commander::Flag.new do |flag|
    flag.name = "tag"
    flag.short = "-t"
    flag.long = "--tag"
    flag.default = ""
    flag.description = "the image tag"
  end
end
