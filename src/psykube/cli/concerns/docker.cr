module Psykube::Commands::Docker
  private macro included
    define_flag build_args : Set(String),
      description: "The build args to add to docker build",
      default: Set(String).new
  end

  BIN = ENV["DOCKER_BIN"]? || `which docker`.strip

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
    args << "--tag=#{image}"
    args << File.dirname(flags.file)
    docker_run args
  end

  def docker_push(tag : String)
    image = tag.includes?(":") ? tag : generator.image(tag)
    docker_run ["push", image]
  end

  def docker_run(args : Array(String))
    puts ([BIN] + args).join(" ") if ENV["PSYKUBE_DEBUG"]? == "true"
    Process.run(BIN, args, output: @output_io, error: @error_io).tap do |process|
      panic "Process: `#{BIN} #{args.join(" ")}` exited unexpectedly".colorize(:red) unless process.success?
    end
  end
end
