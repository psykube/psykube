require "./concerns/*"

class Psykube::CLI::Commands::Command < Admiral::Command
  include KubectlAll
  include Kubectl

  define_help description: "Run a saved command"

  define_flag container : String,
    description: "The name of the container to connect to.",
    short: c
  define_flag nth : Int32,
    description: "Load the nth listed container",
    short: n
  define_argument command : String,
    description: "The command to run in the container."

  def run
    pods = kubectl_get_pods.select(&.status.try(&.phase).== "Running")
    pod = flags.nth ? pods[flags.nth.not_nil!]? || pods.sample : pods.sample
    raise Error.new("No pod to connect to") unless pod
    name = pod.metadata.not_nil!.name.not_nil!
    args = [name]
    args << "-i"
    args << "-t"
    args << "-c #{flags.container}" if flags.container
    args << "--"
    command = actor.manifest.commands[arguments.command]? || actor.manifest.commands["default"]?
    raise Error.new("Invalid command #{arguments.command}") unless command
    args.concat(command.split(" "))
    args.concat(arguments[0..-1])
    kubectl_exec(command: "exec", args: args, input: true)
  end
end
