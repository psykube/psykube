class Psykube::Actor
  def initialize(command : Admiral::Command)
    flags = command.flags
    filename = flags.file
    if File.directory? File.expand_path filename
      @dir = filename
      filename = File.join(filename, ".psykube.yml")
    else
      @dir = File.dirname filename
    end
    File.open(filename) do |io|
      initialize(
        io: io,
        cluster_name: flags.responds_to?(:cluster) ? flags.cluster : nil,
        context: flags.responds_to?(:context) ? flags.context : nil,
        namespace: flags.responds_to?(:namespace) ? flags.namespace : nil,
        basename: flags.responds_to?(:image) ? flags.image : nil,
        tag: flags.responds_to?(:tag) ? flags.tag : nil,
      )
    end
  end
end
