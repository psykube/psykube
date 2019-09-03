require "yaml"

version = YAML.parse(File.read "shard.yml")["version"].to_s
tag = `git describe --tags`.strip
if !tag.empty? && tag != "v#{version}"
  raise "tag (#{tag}) does not match version (v#{version})"
elsif tag
  version = tag.lchop("v")
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
