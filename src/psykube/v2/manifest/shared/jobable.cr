module Psykube::V2::Manifest::Jobable
  def generate_job(actor : Actor, name : String)
    Generator::InlineJob.new(self, actor, name).result
  end
end
