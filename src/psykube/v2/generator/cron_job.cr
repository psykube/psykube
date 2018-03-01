require "./concerns/*"
class Psykube::V2::Generator::CronJob < Generator
  include Concerns::PodHelper

  protected def result
    Pyrite::Api::Batch::V1::CronJob.new(
      metadata: generate_metadata,
      spec: Pyrite::Api::Batch::V1::CronJobSpec.new(
        schedule: manifest.parallelism
      )
    )
  end
end
