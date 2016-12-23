require "./crustache"

basedir = ARGV[0]
extension = ARGV[1].split "/"

puts <<-CODE
begin
  {% begin %}
  %loader = ::Crustache::HashFileSystem.new
CODE

extension.each do |ext|
  Dir.glob("#{basedir}/**/*#{ext}") do |filename|
    File.open(filename) do |io|
      print "  %tmpl = "
      Crustache.parse(io, filename).to_code STDOUT
      puts
    end
    puts "  %loader.register #{filename[(basedir.size + (basedir.ends_with?("/") ? 0 : 1))..-(ext.size + 1)].inspect}, %tmpl"
  end
end

puts <<-CODE
  %loader
  {% end %}
end
CODE
