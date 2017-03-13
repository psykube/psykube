require "../kubernetes/deployment"
require "../kubernetes/pod"
require "./concerns/*"

abstract class Psykube::Generator
  class ReplicationController < Generator
    class InvalidHealthcheck < Exception; end

    include Concerns::PodHelper

    protected def result
      Kubernetes::ReplicationController.new(name).tap do |rc|
        assign_labels(rc, manifest)
        assign_labels(rc, cluster_manifest)
        assign_annotations(rc, manifest)
        assign_annotations(rc, cluster_manifest)
        rc.metadata.namespace = namespace
        if spec = rc.spec
          spec.replicas = manifest.replicas
          spec.template.spec.restart_policy = manifest.restart_policy
          spec.template.spec.volumes = generate_volumes
          spec.template.spec.containers << generate_container
        end
      end
    end
  end
end
