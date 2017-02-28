require "../kubernetes/deployment"
require "../kubernetes/pod"
require "./concerns/*"

class Psykube::Generator
  class Pod < Generator
    include Concerns::PodHelper

    protected def result
      Kubernetes::Pod.new(manifest.name).tap do |pod|
        pod.metadata.namespace = namespace
        if spec = pod.spec
          spec.restart_policy = manifest.restart_policy
          spec.volumes = generate_volumes
          spec.containers << generate_container
        end
      end
    end
  end
end
