require "./spec_helper"

# for ~lambda.json test
class Global
  @@calls = 0

  def self.calls
    @@calls
  end

  def self.calls=(value)
    @@calls = value
  end
end

{% for name in %w(interpolation sections inverted delimiters comments partials ~lambdas) %}
  {{ run "./generate_spec_from_json", "#{name.id}.json" }}
{% end %}
