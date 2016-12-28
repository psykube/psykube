require "../../concerns/mapping"

class Psykube::Kubernetes::Pod::Spec::Container
  Kubernetes.mapping({
    name:                     String,
    image:                    String,
    command:                  String | Array(String) | Nil,
    args:                     Array(String) | Nil,
    working_dir:              String | Nil,
    ports:                    Array(Port) | Nil,
    env:                      Array(Env) | Nil,
    resources:                Resources | Nil,
    volume_mounts:            Array(VolumeMount) | Nil,
    liveness_probe:           Probe | Nil,
    readiness_probe:          Probe | Nil,
    lifecycle:                Lifecycle | Nil,
    termination_message_path: String | Nil,
    image_pull_policy:        String | Nil,
    security_context:         Shared::SecurityContext | Nil,
  })

  def initialize(name, image)
    @name = name
    @image = image
  end
end

require "./container/*"
require "../../../shared/security_context"
