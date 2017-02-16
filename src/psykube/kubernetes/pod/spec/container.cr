require "../../concerns/mapping"
require "../../../shared/security_context"
require "../../../shared/resource_requirements"

class Psykube::Kubernetes::Pod::Spec::Container
  Kubernetes.mapping({
    name:                     String,
    image:                    String,
    command:                  String | Array(String) | Nil,
    args:                     Array(String)?,
    working_dir:              String?,
    ports:                    Array(Port)?,
    env:                      Array(Env)?,
    resources:                Shared::ResourceRequirements?,
    volume_mounts:            Array(VolumeMount)?,
    liveness_probe:           Probe?,
    readiness_probe:          Probe?,
    lifecycle:                Lifecycle?,
    termination_message_path: String?,
    image_pull_policy:        String?,
    security_context:         Shared::SecurityContext?,
    stdin:                    Bool?,
    tty:                      Bool?,
  })

  def initialize(name, image : String)
    @name = name
    @image = image
  end
end

require "./container/*"
