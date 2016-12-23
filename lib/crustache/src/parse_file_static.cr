require "./crustache"

File.open(ARGV[0]) do |io|
  Crustache.parse(io, ARGV[0]).to_code STDOUT
end
