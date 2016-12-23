require "yaml"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Container::Action::HttpGet
  YAML.mapping({
    path:         {type: String, default: "/"},
    port:         UInt16,
    host:         String | Nil,
    scheme:       String | Nil,
    http_headers: {type: Array(HttpHeader), nilable: true, key: "httpHeaders"},
  }, true)

  def initialize(@port : UInt16)
    @path = "/"
  end

  def initialize(@port : UInt16, &block : HttpGet -> _)
    @path = "/"
    block.call(self)
  end
end

require "./http_get/*"
