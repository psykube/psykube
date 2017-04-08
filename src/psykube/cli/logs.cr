require "admiral"
require "./concerns/*"

class Psykube::Commands::Logs < Admiral::Command
  include KubectlAll
  include Kubectl

  define_help description: "Follow the logs of running pods."

  def run
    kubectl_get_pods.map_with_index do |pod, index|
      kubectl_new(
        command: "logs",
        args: [pod.name.to_s],
        flags: {"-f" => true, "--tail" => "1"},
        output: LabeledIO.new(STDOUT, label: pod.name, index: index)
      )
    end.each(&.wait)
  rescue e : Psykube::ParseException
    panic e.message
  end
end
