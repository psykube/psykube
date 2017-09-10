{% if env("EXCLUDE_DOCKER") != "true" %}
module Psykube::CLI::Commands::Docker
  def self.bin
    @@bin ||= ENV["DOCKER_BIN"]? || `which docker`.strip
  end

  private macro included
    define_flag build_args : Set(String),
      description: "The build args to add to docker build.",
      default: Set(String).new
  end

  def build_args
    flags.build_args.to_a +
      generator.manifest.build_args.map(&.join("="))
  end

  def docker_build_and_push(tag)
    docker_build(tag)
    docker_push(tag)
  end

  def docker_build(tag)
    args = ["build"]
    build_args.each do |arg|
      args << "--build-arg=#{arg}"
    end
    image = tag.includes?(":") ? tag : generator.image(tag)
    args << "--cache-from=#{generator.image("latest")}"
    args << "--tag=#{image}"
    args << generator.dir
    docker_run args
  end

  def docker_push(tag : String)
    image = tag.includes?(":") ? tag : generator.image(tag)
    docker_run ["push", image]
  end

  def docker_run(args : Array(String))
    File.exists?(Docker.bin) || panic("docker not found")
    puts (["DEBUG:", Docker.bin] + args).join(" ").colorize(:dark_gray) if ENV["PSYKUBE_DEBUG"]? == "true"
    Process.run(Docker.bin, args, output: @output_io, error: @error_io).tap do |process|
      panic "Process: `#{Docker.bin} #{args.join(" ")}` exited unexpectedly".colorize(:red) unless process.success?
    end
  end
end
{% end %}
