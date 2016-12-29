require "../../../../concerns/mapping"

class Psykube::Kubernetes::Pod::Spec::Container::Action::HttpGet::HttpHeader
  Kubernetes.mapping({
    name:  String,
    value: String,
  })

  def self.from_hash(hash : Hash(String, String))
    hash.map do |name, value|
      new(name, value)
    end
  end

  def self.from_hash(hash : Nil)
    [] of HttpHeader
  end

  def initialize(@name : String, @value : String)
  end
end
