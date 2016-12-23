require "json"

def inspect_hash(hash)
  if hash.is_a?(Hash)
    if hash.empty?
      "{} of String => String"
    else
      pairs = hash.map do |key, value|
        if key == "lambda"
          "#{key.inspect} => #{((value.as(Hash(String, JSON::Type)))["ruby"].as String).gsub(/^proc \{ (?:(?:\|)([^|]+)(?:\|))?/){|m, p| "->(#{p[1]? ? "#{p[1]} : String" : ""}){"}.gsub(/\$/, "Global.").gsub(/1/, "1; Global.calls.to_s").gsub(/false/, "false.to_s")}"
        else
          "#{key.inspect} => #{inspect_hash value}"
        end
      end

      "{#{pairs.join ","}}"
    end
  elsif hash.is_a?(Array)
    if hash.empty?
      "[] of String"
    else
      vals = hash.map{|x| inspect_hash(x).as String}
      "[#{vals.join ","}]"
    end
  else
    "#{hash.inspect}"
  end
end

filename = ARGV[0]

file = (JSON.parse File.read "./spec/mustache-spec/specs/#{filename}").as_h.as Hash(String, JSON::Type)

puts "describe #{filename.inspect} do"
(file["tests"].as Array(JSON::Type)).each do |test|
  test = test.as Hash(String, JSON::Type)

  puts "    it #{test["desc"].inspect} do"
  puts "      template = Crustache.parse #{test["template"].inspect}"
  puts "      expected = #{test["expected"].inspect}"

  puts "      data = #{inspect_hash test["data"]}"

  puts "      fs = Crustache::HashFileSystem.new"
  if test.has_key?("partials")
    (test["partials"].as Hash(String, JSON::Type)).each do |name, tmpl|
      puts "      fs.register #{name.inspect}, Crustache.parse #{tmpl.inspect}"
    end
  end

  puts "      result = Crustache.render template, data, fs"
  puts "      result.should eq expected"
  puts "    end"
end
puts "  end"
