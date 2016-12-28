require "colorize"
require "../generator"

module Psykube::Commands::Helpers
  extend self

  def build_gen(cmd : Commander::Command, arguments : Commander::Arguments, options : Commander::Options)
    cluster_name = arguments[0]?
    file = options.string["file"]
    image = options.string["image"]
    namespace = options.string["namespace"] || "default"

    err_help(cmd, "argument: `<cluster>` required") unless cluster_name
    Generator::List.new(
      file, cluster_name, image, {"namespace" => namespace}
    )
  end

  def build_tag(cmd : Commander::Command, options : Commander::Options)
    file = options.string["file"]
    tag = options.string["tag"]
    Generator::List.new(file).image(tag)
  end

  def build_selector_labels(cmd : Commander::Command, options : Commander::Options)
    file = options.string["file"]
    gen = Generator::Deployment.new(file)
    match_labels = gen.result.spec.selector.match_labels || {} of String => String
    match_labels.map(&.join("=")).join(",")
  end

  def err_help(cmd, msg : String)
    STDERR.puts("  Error: #{msg}".colorize(:red))
    STDERR.puts(cmd.help)
    exit(1)
  end
end
