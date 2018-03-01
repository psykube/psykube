require "./concerns/*"

class Psykube::CLI::Commands::Logs < Admiral::Command
  include KubectlAll
  include Kubectl

  define_help description: "Follow the logs of running pods."

  def run
    kubectl_get_pods.map_with_index do |pod, index|
      pod_name = pod.metadata.not_nil!.name.to_s
      kubectl_new(
        command: "logs",
        args: [pod_name],
        flags: {"-f" => true, "--tail" => "1"},
        output: LabeledIO.new(STDOUT, label: pod_name, index: index)
      )
    end.each(&.wait)
  end
end
