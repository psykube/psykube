require "yaml"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Container::Action::HttpGet::HttpHeader
  YAML.mapping({
    name:  String,
    value: String,
  }, true)

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
