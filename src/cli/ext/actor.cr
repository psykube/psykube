class Psykube::Actor
  getter filename : String?

  def initialize(command : Admiral::Command)
    flags = command.flags
    filename = command.parent.flags.file || flags.file
    filename = File.expand_path filename
    if File.directory? filename
      @working_directory = filename
      filename = File.join(filename, ".psykube.yml")
    else
      @working_directory = File.dirname filename
    end
    @filename = filename
    File.open(filename) do |io|
      initialize(
        io: io,
        cluster_name: command.cluster_name,
        context: flags.responds_to?(:context) ? flags.context : nil,
        namespace: flags.responds_to?(:namespace) ? flags.namespace : nil,
        basename: flags.responds_to?(:image) ? flags.image : nil,
        tag: flags.responds_to?(:tag) ? flags.tag : nil,
      )
    end
  rescue e : IO::Error
    raise Error.new e.message
  end

  def initialize(command : Admiral::Command, filename : String)
    flags = command.flags
    filename = File.expand_path filename
    if File.directory? filename
      @working_directory = filename
      filename = File.join(filename, ".psykube.yml")
    else
      @working_directory = File.dirname filename
    end
    @filename = filename
    File.open(filename) do |io|
      initialize(
        io: io,
        context: flags.responds_to?(:context) ? flags.context : nil,
        namespace: flags.responds_to?(:namespace) ? flags.namespace : nil,
        basename: flags.responds_to?(:image) ? flags.image : nil,
        tag: flags.responds_to?(:tag) ? flags.tag : nil,
      )
    end
  rescue e : IO::Error
    raise Error.new e.message
  end
end
