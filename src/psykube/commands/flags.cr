require "commander"

module Psykube::Commands::Flags
  Namespace = Commander::Flag.new do |flag|
    flag.name = "namespace"
    flag.short = "-n"
    flag.long = "--namespace"
    flag.default = "default"
    flag.description = "The namespace to deploy in"
  end

  CopyNamespace = Commander::Flag.new do |flag|
    flag.name = "copy-namespace"
    flag.short = "-c"
    flag.long = "--copy-namespace"
    flag.default = ""
    flag.description = "The namespace copy"
  end

  Push = Commander::Flag.new do |flag|
    flag.name = "push"
    flag.short = "-p"
    flag.long = "--push"
    flag.default = true
    flag.description = "Push to the docker registry"
  end

  AllocateStdIn = Commander::Flag.new do |flag|
    flag.name = "stdin"
    flag.short = "-i"
    flag.long = "--stdin"
    flag.default = false
    flag.description = "Allocate Stdin"
  end

  AllocateTty = Commander::Flag.new do |flag|
    flag.name = "tty"
    flag.short = "-t"
    flag.long = "--tty"
    flag.default = false
    flag.description = "Allocate TTY"
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
    flag.default = "gitsha-#{`git rev-parse HEAD`.strip}"
    flag.description = "the image tag"
  end

  Resources = Commander::Flag.new do |flag|
    flag.name = "resources"
    flag.short = "-r"
    flag.long = "--resources"
    flag.default = "cm,secrets,deployments,services,pvc"
    flag.description = "the resources to copy"
  end

  BuildArgs = Commander::Flag.new do |flag|
    flag.name = "build-args"
    flag.short = "-a"
    flag.long = "--build-args"
    flag.default = ""
    flag.description = "docker build args"
  end
end
