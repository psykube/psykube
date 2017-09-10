require "admiral"
require "./concerns/*"

class Psykube::CLI::Commands::PortForward < Admiral::Command
  include KubectlAll
  include Kubectl

  define_help description: "Forward one or more local ports to a running pod for the application."

  private def help_usage
    <<-HELP
    Usage:
      #{program_name} [...flags] <cluster> [LOCAL_PORT:]REMOTE_PORT [...[LOCAL_PORT_N:]REMOTE_PORT_N]

    #{HELP["description"]}

    Examples:
      # Listen on ports 5000 and 6000 locally, forwarding data to/from ports 5000 and 6000 in the pod
      #{program_name} staging 5000 6000

      # Listen on port 8888 locally, forwarding to 5000 in the pod
      #{program_name} staging 8888:5000

      # Listen on a random port locally, forwarding to 5000 in the pod
      #{program_name} staging :5000

      # Listen on a random port locally, forwarding to 5000 in the pod
      #{program_name} staging 0:5000

    HELP
  end

  def run
    kubectl_exec(command: "port-forward", args: [kubectl_get_pods.first.metadata.not_nil!.name.to_s] + arguments[0..-1])
  end
end
