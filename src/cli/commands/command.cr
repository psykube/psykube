require "./concerns/*"

class Psykube::CLI::Commands::Command < Admiral::Command
  include KubectlAll
  include Kubectl

  define_help description: "Run a saved command"

  define_flag stdin : Bool,
    description: "Allocate stdin.",
    short: i
  define_flag tty : Bool,
    description: "Allocate tty.",
    short: t
  define_flag container : String,
    description: "The name of the container to connect to.",
    short: c
  define_flag nth : Int32,
    description: "Load the nth listed container",
    short: n
  define_argument command,
    description: "The command to run in the container.",
    required: true

  def run
    pods = kubectl_get_pods.select(&.status.try(&.phase).== "Running")
    pod = flags.nth ? pods[flags.nth.not_nil!]? || pods.sample : pods.sample
    raise Error.new("No pod to connect to") unless pod
    name = pod.metadata.not_nil!.name.not_nil!
    args = [name]
    args << "-i" if flags.stdin
    args << "-t" if flags.tty
    args << "-c #{flags.container}" if flags.container
    args << "--"
    args << (actor.manifest.commands.try(&.[arguments.command]?) || raise Error.new("Invalid command #{arguments.command}"))
    args.concat(arguments[0..-1])
    kubectl_exec(command: "exec", args: args, input: flags.stdin)
  end
end
