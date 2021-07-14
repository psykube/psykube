require "./concerns/*"

class Psykube::CLI::Commands::Exec < Admiral::Command
  include KubectlAll
  include Kubectl

  define_help description: "Exec a command in a running container."

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
    pod = flags.nth ? kubectl_get_pods[flags.nth.not_nil!]? : kubectl_get_pods.sample
    pod = kubectl_get_pods.sample unless pod
    raise Error.new("No pod to connect to") unless pod
    name = pod.metadata.not_nil!.name.not_nil!
    args = [name]
    args << "-i" if flags.stdin
    args << "-t" if flags.tty
    args << "-c #{flags.container}" if flags.container
    args << "--"
    args << arguments.command
    args.concat(arguments[0..-1])
    kubectl_exec(command: "exec", args: args, input: flags.stdin)
  end
end
