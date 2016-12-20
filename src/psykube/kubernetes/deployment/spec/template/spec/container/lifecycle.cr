require "yaml"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Container
  class Lifecycle
    YAML.mapping({
      post_start: {type: Event, nilable: true, key: "postStart"},
      pre_stop:   {type: Event, nilable: true, key: "preStop"},
    }, true)
  end
end

require "./lifecycle/*"
