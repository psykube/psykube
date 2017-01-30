require "yaml"
version = YAML.parse(File.read "shard.yml")["version"].to_s
if !ENV["TRAVIS_TAG"]?.to_s.empty? && ENV["TRAVIS_TAG"] != "v#{version}"
  raise "TRAVIS_TAG does not match version"
else
  match_rxp = /\d+$/
  digits = version.match(match_rxp)
  if digits
    inc = digits[0].to_i + 1
    version = version.sub(match_rxp, "#{inc} (#{`git rev-parse --short HEAD`.strip})")
  end
end
puts <<-crystal
VERSION = #{version.inspect}
crystal
