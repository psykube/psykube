require "commander"
require "./psykube/generator"

cli = Commander::Command.new do |cmd|
  cmd.use = "psykube"
  cmd.long = "A tool for interacting and deploying to kubernetes clusters within CI/CD environments."

  file_flag = Commander::Flag.new do |flag|
    flag.name = "file"
    flag.short = "-f"
    flag.long = "--file"
    flag.default = "./.psykube.yml"
    flag.description = "The psykube file to use"
  end

  namespace_flag = Commander::Flag.new do |flag|
    flag.name = "namespace"
    flag.short = "-n"
    flag.long = "--namespace"
    flag.default = "default"
    flag.description = "The namespace to deploy in"
  end

  # cmd.flags.add namespace_flag

  verbose_flag = Commander::Flag.new do |flag|
    flag.name = "verbose"
    flag.short = "-v"
    flag.long = "--verbose"
    flag.default = false
    flag.description = "Enable more verbose logging."
  end

  context_flag = Commander::Flag.new do |flag|
    flag.name = "context"
    flag.short = "-c"
    flag.long = "--context"
    flag.default = ""
    flag.description = "The kubernetes context to use"
  end

  cmd.run do |options, arguments|
    puts cmd.help # => Render help screen
  end

  cmd.commands.add do |cmd|
    cmd.use = "generate <cluster>"
    cmd.short = "Generates the kubernetes manifests"
    cmd.long = cmd.short
    cmd.flags.add namespace_flag
    cmd.flags.add file_flag
    cmd.run do |options, arguments|
      if arguments[0]?
        gen = Psykube::Generator.new(
          options.string["file"],
          arguments[0],
          "latest",
          {
            "namespace" => {"name" => options.string["namespace"]},
          }
        )
        puts gen.to_yaml
      else
        STDERR.puts(cmd.help)
        exit(1)
      end
    end
  end
end

Commander.run(cli, ARGV)
