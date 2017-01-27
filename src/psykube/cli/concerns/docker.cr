module Psykube::Commands::Docker
  private macro included
    define_flag build_args : Set(String),
      description: "The build args to add to docker build",
      default: Set(String).new
  end

  BIN = ENV["DOCKER_BIN"]? || `which docker`.strip

  def docker_build_and_push(tag)
    docker_build(tag)
    docker_push(tag)
  end

  def docker_build(tag)
    args = ["build"]
    flags.build_args.each do |arg|
      args << "--build-arg=#{arg}"
    end
    args << "--tag=#{tag}"
    args << "."
    Process.run(BIN, args, output: @output_io, error: @error_io).tap do |process|
      raise "docker exited unexpectedly" unless process.success?
    end
  end

  def docker_push(tag)
    args = ["push", tag]
    Process.run(BIN, args, output: @output_io, error: @error_io).tap do |process|
      raise "docker exited unexpectedly" unless process.success?
    end
  end
end
