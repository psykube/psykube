module Psykube::CLI::Commands::Docker
  def self.bin
    @@bin ||= ENV["DOCKER_BIN"]? || `which docker`.strip
  end

  private macro included
    define_flag build_args : Set(String),
      description: "The build args to add to docker build.",
      default: Set(String).new
    define_flag login : Bool, default: true, description: "Don't login with the specified image pull secrets before pushing."
  end

  def build_args
    flags.build_args.to_a
  end

  def docker_build_and_push(*args)
    docker_build(*args)
    docker_push(*args)
  end

  def docker_build(build_contexts : Array(BuildContext), tag : String? = nil)
    build_contexts.each { |c| docker_build c }
  end

  def docker_build(build_context : BuildContext, tag : String? = nil)
    Dir.cd actor.working_directory do
      args = ["build"]
      build_args.each do |arg|
        args << "--build-arg=#{arg}"
      end
      build_context.args.each do |arg|
        args << "--build-arg=#{arg}"
      end
      image = tag && tag.includes?(":") ? tag : build_context.image(tag)
      # args << "--tag=#{image}"
      args << "--file=#{build_context.dockerfile}" if build_context.dockerfile
      # args << build_context.context
      docker_run args + [build_context.context]
    end
  end

  def docker_push(build_contexts : Array(BuildContext), tag : String? = nil)
    build_contexts.each { |c| docker_push c }
  end

  def docker_push(build_context : BuildContext, tag : String? = nil)
    image = tag && tag.includes?(":") ? tag : build_context.image(tag)
    if flags.login && (login = build_context.login)
      password = IO::Memory.new.tap(&.puts login.password).tap(&.rewind)
      docker_run ["login", login.server, "-u=#{login.username}", "--password-stdin"], input: password
    end
    docker_run ["push", image]
  end

  def docker_run(args : Array(String), *, input = Process::Redirect::Close, output = @output_io)
    File.exists?(Docker.bin) || panic("docker not found")
    puts (["DEBUG:", Docker.bin] + args).join(" ").colorize(:dark_gray) if ENV["PSYKUBE_DEBUG"]? == "true"
    Process.run(Docker.bin, args, input: input, output: output, error: @error_io).tap do |process|
      panic "Process: `#{Docker.bin} #{args.join(" ")}` exited unexpectedly".colorize(:red) unless process.success?
    end
  end
end
