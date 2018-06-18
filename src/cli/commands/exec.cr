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

  define_argument command,
    description: "The command to run in the container",
    required: true

  def run
    pod = kubectl_get_pods.first
    args = [pod.metadata.not_nil!.name.not_nil!]
    args << "-i" if flags.stdin
    args << "-t" if flags.tty
    args << "--"
    args << arguments.command
    args.concat(arguments[0..-1])
    kubectl_exec(command: "exec", args: args, input: flags.stdin)
  end
end
