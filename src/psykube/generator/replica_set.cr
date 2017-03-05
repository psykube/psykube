require "../kubernetes/deployment"
require "../kubernetes/pod"
require "./concerns/*"

abstract class Psykube::Generator
  class ReplicaSet < Generator
    class InvalidHealthcheck < Exception; end

    include Concerns::PodHelper

    protected def result
      Kubernetes::ReplicaSet.new(manifest.name).tap do |rs|
        assign_labels(rs, manifest)
        assign_labels(rs, cluster_manifest)
        assign_annotations(rs, manifest)
        assign_annotations(rs, cluster_manifest)
        rs.metadata.namespace = namespace
        if spec = rs.spec
          spec.replicas = manifest.replicas
          spec.template.spec.restart_policy = manifest.restart_policy
          spec.template.spec.volumes = generate_volumes
          spec.template.spec.containers << generate_container
        end
      end
    end
  end
end
