require "yaml"
require "json"

class Psykube::Manifest::Percentage

  class InvalidError < Exception ; end

  def initialize(pull : YAML::PullParser)
    initialize pull.read_scalar
  rescue ex
    raise YAML::ParseException.new(ex.message.not_nil!, 0, 0)
  end

  def initialize(pull : JSON::PullParser)
    initialize pull.read_string
  rescue ex
    raise JSON::ParseException.new(ex.message.not_nil!, 0, 0)
  end

  def initialize(@value : String)
    raise InvalidError.new("#{value} is not a valid percentage") unless value.ends_with?('%')
    initialize value.chomp('%').to_u32
  end

  def initialize(value : Int32)
    initialize value.to_u32
  end

  def initialize(@value : UInt32)
  end

  def to_s(io)
    "#{@value}%".to_s(io)
  end

  def to_json(io)
    to_s.to_json(io)
  end

  def to_yaml(io)
    to_s.to_yaml(io)
  end

end
