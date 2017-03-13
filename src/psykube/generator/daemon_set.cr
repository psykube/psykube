require "../kubernetes/deployment"
require "../kubernetes/pod"
require "./concerns/*"

abstract class Psykube::Generator
  class DaemonSet < Generator
    class InvalidHealthcheck < Exception; end

    include Concerns::PodHelper

    protected def result
      Kubernetes::DaemonSet.new(name).tap do |ds|
        assign_labels(ds, manifest)
        assign_labels(ds, cluster_manifest)
        assign_annotations(ds, manifest)
        assign_annotations(ds, cluster_manifest)
        ds.metadata.namespace = namespace
        if spec = ds.spec
          spec.template.spec.restart_policy = manifest.restart_policy
          spec.template.spec.volumes = generate_volumes
          spec.template.spec.containers << generate_container
        end
      end
    end
  end
end
