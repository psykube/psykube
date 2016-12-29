require "../../../../concerns/mapping"

class Psykube::Kubernetes::Pod::Spec::Container::Action::HttpGet
  Kubernetes.mapping({
    path:         {type: String, default: "/"},
    port:         UInt16,
    host:         String | Nil,
    scheme:       String | Nil,
    http_headers: Array(HttpHeader) | Nil,
  })

  def initialize(@port : UInt16)
    @path = "/"
  end

  def initialize(@port : UInt16, &block : HttpGet -> _)
    @path = "/"
    block.call(self)
  end
end

require "./http_get/*"
