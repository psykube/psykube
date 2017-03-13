require "../kubernetes/deployment"
require "../kubernetes/pod"
require "./concerns/*"

abstract class Psykube::Generator
  class Job < Generator
    class InvalidHealthcheck < Exception; end

    include Concerns::PodHelper

    protected def result
      Kubernetes::Job.new(name).tap do |job|
        assign_labels(job, manifest)
        assign_labels(job, cluster_manifest)
        assign_annotations(job, manifest)
        assign_annotations(job, cluster_manifest)
        job.metadata.namespace = namespace
        if spec = job.spec
          spec.parallelism = manifest.parallelism
          spec.completions = manifest.completions
          spec.template.spec.restart_policy = manifest.restart_policy
          spec.template.spec.volumes = generate_volumes
          spec.template.spec.containers << generate_container
        end
      end
    end
  end
end
