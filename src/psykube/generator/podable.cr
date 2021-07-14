class Psykube::Generator::Podable < ::Psykube::Generator
  protected def result
    case manifest.type
    when "Deployment"
      Deployment.result(self)
    when "Cron"
      CronJob.result(self)
    when "Job"
      Job.result(self)
    when "StatefulSet"
      StatefulSet.result(self)
    when "DaemonSet"
      DaemonSet.result(self)
    when "Pod"
      Pod.result(self)
    else
      raise "Invalid type: `#{manifest.type}`"
    end
  end
end
