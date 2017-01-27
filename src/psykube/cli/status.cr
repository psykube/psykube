require "admiral"
require "./concerns/*"

class Psykube::Commands::Status < Admiral::Command
  include KubectlAll
  include Kubectl

  define_help description: "List the status of the kubernetes pods."

  def run
    statuses = kubectl_get_pods(phase: nil).map do |pod|
      case pod
      when Kubernetes::Pod
        if (status = pod.status)
          age_span = (Time.now - Time.parse(status.start_time.to_s, "%FT%X%z"))
          age_string = ""
          age_string += "#{age_span.total_days.to_i}d" if age_span.total_days.to_i > 0
          age_string += "#{age_span.hours.to_i}h" if age_span.hours.to_i > 0
          age_string += "#{age_span.minutes.to_i}m" if age_span.minutes.to_i > 0
          age_string += "#{age_span.seconds.to_i}s" unless age_string.size > 0
          {
            NAME:     pod.metadata.name.to_s,
            STATUS:   status.phase.to_s,
            RESTARTS: status.container_statuses.try(&.map(&.try &.restart_count).reduce(0) { |a, b| a + b }).to_s,
            AGE:      age_string,
          }
        end
      end
    end.compact
    puts "No pods are running" if statuses.empty?
    pad = 4
    statuses[0].keys.each do |name|
      print name.to_s.ljust(([name.to_s] + statuses.map(&.[name])).map(&.size).sort[-1] + pad)
    end
    print "\n"
    statuses.each do |status|
      status.each do |name, value|
        print value.to_s.ljust(([name.to_s] + statuses.map(&.[name])).map(&.size).sort[-1] + pad)
      end
      print "\n"
    end
  end
end
