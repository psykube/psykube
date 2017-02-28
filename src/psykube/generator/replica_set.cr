require "../kubernetes/deployment"
require "../kubernetes/pod"
require "./concerns/*"

class Psykube::Generator
  class ReplicaSet < Generator
    class InvalidHealthcheck < Exception; end

    include Concerns::PodHelper

    protected def result
      Kubernetes::ReplicaSet.new(manifest.name).tap do |rs|
        rs.metadata.namespace = namespace
        if spec = rs.spec
          spec.template.spec.restart_policy = manifest.restart_policy
          spec.template.spec.volumes = generate_volumes
          spec.template.spec.containers << generate_container
        end
      end
    end
  end
end
