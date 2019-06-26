module Psykube::CLI::Commands::Docker
  def self.bin
    @@bin ||= ENV["DOCKER_BIN"]? || `which docker`.strip
  end

  private macro included
    define_flag build_args : Set(String),
      description: "The build args to add to docker build.",
      default: Set(String).new
    define_flag login : Bool, default: true, description: "Don't login with the specified image pull secrets before pushing."
    define_flag quiet_build : Bool, default: true, description: "Quiet docker output", short: q
  end

  def build_args
    flags.build_args.to_a
  end

  def docker_build_and_push(*args)
    docker_build(*args)
    docker_push(*args)
  end

  def docker_build(build_contexts : Array(BuildContext), tag : String? = nil)
    build_contexts.each { |c| docker_build c, tag }
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
      args << "--file=#{build_context.dockerfile}" if build_context.dockerfile
      build_context.cache_from.each do |c|
        args << "--cache-from=#{c}"
      end
      build_context.build_tags.each do |t|
        args << "--tag=#{t}"
      end
      args << "--quiet" if flags.quiet_build
      docker_run args + [build_context.context]
      io = IO::Memory.new
      docker_run args + ["-q"] + [build_context.context], output: io
      sha = io.rewind.gets_to_end.strip
      build_context.image, build_context.tag = tag.split(':') if tag && tag.includes?(":")
      build_context.tag ||= sha.sub(':', '-')
      docker_run ["tag", sha, build_context.image(tag)]
    end
  end

  def docker_push(build_contexts : Array(BuildContext), tag : String? = nil)
    build_contexts.each { |c| docker_push c, tag }
  end

  def docker_push(build_context : BuildContext, tag : String? = nil)
    image = tag && tag.includes?(":") ? tag : build_context.image(tag)
    if flags.login && (login = build_context.login)
      password = IO::Memory.new.tap(&.puts login.password).tap(&.rewind)
      docker_run ["login", login.server, "-u=#{login.username}", "--password-stdin"], input: password
    end
    docker_run ["push", build_context.image(tag)]
  end

  def docker_run(args : Array(String), *, input = Process::Redirect::Close, output = @output_io)
    File.exists?(Docker.bin) || panic("docker not found")
    puts (["DEBUG:", Docker.bin] + args).join(" ").colorize(:dark_gray) if ENV["PSYKUBE_DEBUG"]? == "true"
    Process.run(Docker.bin, args, input: input, output: output, error: @error_io).tap do |process|
      panic "Process: `#{Docker.bin} #{args.join(" ")}` exited unexpectedly".colorize(:red) unless process.success?
    end
  end
end
