require "yaml"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Container
  YAML.mapping({
    name:                     String,
    image:                    String,
    command:                  String | Array(String) | Nil,
    args:                     Array(String) | Nil,
    working_dir:              {type: String, nilable: true, key: "workingDir"},
    ports:                    Array(Port) | Nil,
    env:                      Array(Env) | Nil,
    resources:                Resources | Nil,
    volume_mounts:            {type: Array(VolumeMount), nilable: true, key: "volumeMounts"},
    liveness_probe:           {type: Probe, nilable: true, key: "livenessProbe"},
    readiness_probe:          {type: Probe, nilable: true, key: "readinessProbe"},
    lifecycle:                Lifecycle | Nil,
    termination_message_path: {type: String, key: "terminationMessagePath", nilable: true},
    image_pull_policy:        {type: String, key: "imagePullPolicy", nilable: true},
    security_context:         {type: Psykube::Kubernetes::Shared::SecurityContext, nilable: true, key: "securityContext"},
  }, true)

  def initialize(name, image)
    @name = name
    @image = image
  end
end

require "./container/*"
require "../../../../shared/security_context"
