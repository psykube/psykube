require "colorize"
require "../generator"

module Psykube::Commands::Helpers
  extend self

  def build_gen(cmd : Commander::Command, arguments : Commander::Arguments, options : Commander::Options)
    cluster_name = arguments[0]? || ""
    file = options.string["file"]
    image = options.string["image"]
    namespace = options.string["namespace"] || "default"

    Generator::List.new(file, cluster_name, image, {"namespace" => namespace}).tap do |gen|
      unless gen.manifest.clusters.empty? || !cluster_name.empty?
        STDERR.puts "WARNING: No cluster specified, this may have unintented results!".colorize(:yellow)
      end
    end
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

  def add_build_args(args : Array, options : Commander::Options)
    file = options.string["file"]
    manifest_args = (Generator.new(file).manifest.build_args || {} of String => String).map(&.join("="))
    cli_args = options.string["build-args"].split(",").reject(&.empty?)
    build_args = manifest_args | cli_args
    args.concat build_args.map { |arg| "--build-arg=#{arg}" } unless build_args.empty?
  end

  def get_pods(cmd : Commander::Command, options : Commander::Options, phase : String? = "Running")
    namespace = options.string["namespace"]
    selector_labels = Helpers.build_selector_labels(cmd, options)
    io = IO::Memory.new
    Process.run(ENV["KUBECTL_BIN"], ["--namespace=#{namespace}", "get", "pods", "--selector=#{selector_labels}", "-o=json"], output: io, error: STDERR).tap do |process|
      exit(process.exit_status) unless process.success?
    end
    io.rewind
    pod_list = Kubernetes::List.from_json(io)
    pods = pod_list.items.select do |pod|
      if pod.is_a?(Kubernetes::Pod)
        next pod unless phase
        (pod.status || Kubernetes::Pod::Status.new).phase == phase
      end
    end

    # Exec into the pod
    if pods.any?(&.is_a? Kubernetes::Pod)
      pods
    else
      raise "There are no running pods, try running `psykube status`"
    end
  end
end
