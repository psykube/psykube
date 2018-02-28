class Psykube::Actor
  def initialize(command : Admiral::Command)
    flags = command.flags
    arguments = command.arguments
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
        cluster_name: arguments.responds_to?(:cluster) ? arguments.cluster : nil,
        context: arguments.responds_to?(:context) ? arguments.context : nil,
        namespace: arguments.responds_to?(:namespace) ? arguments.namespace : nil,
        basename: arguments.responds_to?(:image) ? arguments.image : nil,
        tag: arguments.responds_to?(:tag) ? arguments.tag : nil,
      )
    end
  end
end
