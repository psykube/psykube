require "./psykube/generator"

puts Psykube::Generator.new(".psykube.yaml", ARGV[0]).to_yaml
