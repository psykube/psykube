class Psykube::Actor
  def initialize(command : Admiral::Command)
    flags = command.flags
    filename = command.parent.flags.file || flags.file
    if File.directory? File.expand_path filename
      @working_directory = filename
      filename = File.join(filename, ".psykube.yml")
    else
      @working_directory = File.dirname filename
    end
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
end
