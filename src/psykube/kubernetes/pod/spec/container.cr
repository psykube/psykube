require "../../concerns/mapping"

class Psykube::Kubernetes::Pod::Spec::Container
  Kubernetes.mapping({
    name:                     String,
    image:                    String,
    command:                  String | Array(String) | Nil,
    args:                     Array(String)?,
    working_dir:              String?,
    ports:                    Array(Port)?,
    env:                      Array(Env)?,
    resources:                Resources?,
    volume_mounts:            Array(VolumeMount)?,
    liveness_probe:           Probe?,
    readiness_probe:          Probe?,
    lifecycle:                Lifecycle?,
    termination_message_path: String?,
    image_pull_policy:        String?,
    security_context:         Shared::SecurityContext?,
  })

  def initialize(name, image)
    @name = name
    @image = image
  end
end

require "./container/*"
require "../../../shared/security_context"
