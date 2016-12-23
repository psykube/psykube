require "./syntax"

module Crustache
  abstract class FileSystem
    abstract def load(value) : Syntax::Template

    def load!(value)
      if tmpl = self.load value
        return tmpl
      else
        raise "#{value} is not found"
      end
    end
  end

  class HashFileSystem < FileSystem
    def initialize
      @tmpls = {} of String => Syntax::Template
    end

    def register(name, tmpl)
      @tmpls[name] = tmpl
    end

    def load(value)
      return @tmpls[value]?
    end
  end

  class ViewLoader < FileSystem
    EXTENSION = [".mustache", ".html", ""]

    def initialize(@basedir : String, @use_cache = false, @extension : Array(String) = EXTENSION )
      @cache = {} of String => Syntax::Template?
    end

    def load(value)
      if @cache.has_key?(value)
        return @cache[value]
      end

      @extension.each do |ext|
        filename = "#{@basedir}/#{value}"
        filename_ext = "#{filename}#{ext}"
        if File.exists?(filename_ext)
          tmpl = Crustache.parse_file filename_ext
          @cache[value] = tmpl if @use_cache
          return tmpl
        end
      end

      @cache[value] = nil if @use_cache
      return nil
    end
  end
end
