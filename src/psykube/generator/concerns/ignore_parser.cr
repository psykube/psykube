abstract class Psykube::Generator
  struct Concerns::IgnoreParser
    getter ignores : Array(Regex) = [] of Regex
    getter exceptions : Array(Regex) = [] of Regex
    getter context : String

    def prepare_regexes(patterns : Array(String))
      patterns.map { |pattern| prepare_regexes pattern }
    end

    def prepare_regexes(pattern : String)
      Regex.new prepare_partial_regex(pattern)
    end

    def prepare_regex_pattern(pattern : String)
      Regex.escape(pattern).gsub("**", "(.+)").gsub(/\\?\*/, "([^\\/]+)")
    end

    def prepare_partial_regex(pattern : String)
      patterns = pattern.split('/')
      String.build do |s|
        s << "^#{context}/" && patterns.shift if patterns[0]? == ""
        patterns.map_with_index do |item, index|
          s << '('
          s << "[\/]?(" if index > 0
          s << prepare_regex_pattern(item)
          s << "\\b"
          s << "|$)" if index > 0
          s << ')'
        end
      end
    end

    def initialize(filename : String, context : String? = nil)
      if context
        @context = context
        filename = File.join(context, filename)
      else
        @context = File.dirname filename
      end
      return unless File.exists?(filename)
      File.open(filename) do |io|
        initialize(io, @context)
      end
    end

    def initialize(io : IO, @context : String)
      ignores = [] of String
      exceptions = [] of String
      io.each_line
        .map(&.strip)
        .reject { |l| l[0]? == '#' || l.empty? }
        .each { |l| l[0]? == '!' && l[1]? ? exceptions << l[1..-1] : ignores << l }

      {% for list, i in %w(ignores exceptions) %}
      {{ list.id }} = prepare_regexes({{ list.id }})
      @{{ list.id }} = {{ list.id }}
    {% end %}
    end

    def filter
      files = Dir.glob(File.join(context, "**/*"))
      start = Time.now
      ignored = files.select { |file| ignores.any? { |i| file =~ i } }
      not_ignored = files.select { |file| exceptions.any? { |e| file =~ e } }
      (files - ignored) + not_ignored
    end
  end
end
