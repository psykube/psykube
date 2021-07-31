class Psykube::Generator::Podable < ::Psykube::Generator
  alias Resource = Pyrite::Api::Apps::V1::Deployment | Pyrite::Api::Batch::V1beta1::CronJob | Pyrite::Api::Batch::V1::Job | Pyrite::Api::Apps::V1::StatefulSet | Pyrite::Api::Apps::V1::DaemonSet | Pyrite::Api::Core::V1::Pod

  protected def result : Resource
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
      raise Psykube::Error.new "Invalid type: `#{manifest.type}`"
    end
  end
end
