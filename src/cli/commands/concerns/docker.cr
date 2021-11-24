module Psykube::CLI::Commands::Docker
  def self.bin
    @@bin ||= ENV["DOCKER_BIN"]? || `which docker`.strip
  end

  private macro included
    define_flag build_args : Set(String),
      description: "The build args to add to docker build.",
      default: Set(String).new
    define_flag login : Bool, default: true, description: "Don't login with the specified image pull secrets before pushing."
    define_flag docker_credentials : String, description: "Docker credentials to push with."
    define_flag quiet_build : Bool, default: false, description: "Quiet docker output", short: q
  end

  def build_args
    flags.build_args.to_a
  end

  def docker_build_and_push(*args)
    docker_build(*args)
    docker_push(*args)
  end

  def docker_login(build_context : BuildContext)
    server = ""
    username = nil
    password = nil
    if (login = build_context.login)
      server = login.server
      username = login.username
      password = login.password
    end
    if (creds = flags.docker_credentials)
      username, password = creds.split(":")
    end
    if username && password
      password = IO::Memory.new.tap(&.puts password).tap(&.rewind)
      docker_run ["login", server, "-u=#{username}", "--password-stdin"], input: password
    end
  end

  def docker_build(build_contexts : Array(BuildContext), tag : String? = nil)
    build_contexts.each { |c| docker_build c, tag }
  end

  def docker_build(build_context : BuildContext, tag : String? = nil)
    docker_login(build_context)
    build_context.cache_from.each do |c|
      build_context.stages.each do |stage|
        docker_run ["pull", "--platform=#{build_context.platform}", "#{c}-#{stage}"], allow_failure: true
      end
      docker_run ["pull", "--platform=#{build_context.platform}", c], allow_failure: true
    end

    Dir.cd actor.working_directory do
      build_context.stages.each do |stage|
        build_image(build_context, tag, stage)
      end
      build_image(build_context, tag, build_context.target)
    end
  end

  def build_image(build_context : BuildContext, tag : String? = nil, target : String? = nil)
    iidfile = File.tempfile("iidfile")
    args = ["build"]
    args << "--platform=#{build_context.platform}"
    build_args.each do |arg|
      args << "--build-arg=#{arg}"
    end
    build_context.args.each do |arg|
      args << "--build-arg=#{arg}"
    end
    args << "--file=#{build_context.dockerfile}" if build_context.dockerfile
    args << "--quiet" if flags.quiet_build
    args << "--target=#{target}" if target
    build_context.cache_from.each do |c|
      build_context.stages.each do |stage|
        args << "--cache-from=#{c}-#{stage}" unless stage == target || container_missing("#{c}-#{stage}")
      end
      c += "-#{target}" if target
      args << "--cache-from=#{c}" unless container_missing(c)
    end
    build_context.build_tags.each do |t|
      t += "-#{target}" if target
      args << "--tag=#{t}"
    end
    args << "--tag=#{tag}" if tag
    if build_context.tag
      args << "--tag=#{build_context.image}"
    else
      args << "--iidfile=#{iidfile.path}" unless build_context.tag
    end
    docker_run args + [build_context.context]
    unless build_context.tag
      sha = File.read(iidfile.path).strip
      iidfile.delete
      build_context.image, build_context.tag = tag.split(':') if tag && tag.includes?(":")
      build_context.tag = sha.sub(':', '-')
      docker_run ["tag", sha, build_context.image(tag)]
    end
  end

  def docker_push(build_contexts : Array(BuildContext), tag : String? = nil)
    build_contexts.each { |c| docker_push c, tag }
  end

  def docker_push(build_context : BuildContext, tag : String? = nil)
    docker_login(build_context)

    image = tag && tag.includes?(":") ? tag : build_context.image(tag)
    build_context.stages.each do |stage|
      push_tags(build_context, stage)
    end
    push_tags(build_context, build_context.target)
    docker_run ["push", build_context.image(tag)] if tag
    docker_run ["push", build_context.image]
  end

  def push_tags(build_context : BuildContext, target : String? = nil)
    build_context.build_tags.each do |build_tag|
      build_tag += "-#{target}" if target
      docker_run ["push", build_tag]
    end
  end

  def docker_run(args : Array(String), *, input = Process::Redirect::Close, output = @output_io, allow_failure = false)
    File.exists?(Docker.bin) || panic("docker not found")
    puts (["DEBUG:", Docker.bin] + args).join(" ").colorize(:dark_gray) if ENV["PSYKUBE_DEBUG"]? == "true"
    Process.run(Docker.bin, args, input: input, output: output, error: @error_io).tap do |process|
      panic "Process: `#{Docker.bin} #{args.join(" ")}` exited unexpectedly".colorize(:red) unless process.success? || allow_failure
    end
  end

  private def container_missing(container : String)
    stdout = IO::Memory.new
    docker_run ["images", container, "-q"], output: stdout
    stdout.to_s.empty?
  end
end
