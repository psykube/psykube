require "./crustache/**"

module Crustache
  # :nodoc:
  OPEN_TAG = "{{".to_slice
  # :nodoc:
  CLOSE_TAG = "}}".to_slice

  DEFAULT_FILENAME = "__str__"

  alias Template = Syntax::Template

  def self.parse(io : IO, filename = DEFAULT_FILENAME, row = 1)
    Parser.new(OPEN_TAG, CLOSE_TAG, io, filename, row).parse
  end

  def self.parse(string : String, filename = DEFAULT_FILENAME, row = 1)
    self.parse IO::Memory.new(string), filename, row
  end

  def self.parse_file(filename)
    self.parse(File.new(filename), filename, 1)
  end

  macro parse_file_static(filename)
    {{ run("./parse_file_static.cr", filename) }}
  end

  def self.loader(basedir, extension = ViewLoader::EXTENSION)
    ViewLoader.new basedir, extension: extension
  end

  macro loader_static(basedir, extension = [".mustache", ".html", ""])
    {{ run("./loader_static.cr", basedir, extension.join("/")) }}
  end

  def self.render(tmpl, model, fs = HashFileSystem.new)
    String.build do |io|
      self.render tmpl, model, fs, io
    end
  end

  def self.render(tmpl, model, fs, io)
    tmpl.visit Renderer.new OPEN_TAG, CLOSE_TAG, Context(typeof(Context.resolve_scope_type(model))).new(model), fs, io
  end
end

module Mustache
  macro embed(filename, io_name, model = nil)
    ::Crustache.render(::Crustache.parse_file_static({{ filename }}), {{ model }}, ::Crustache::HashFileSystem.new, {{ io_name.id }})
  end

  macro def_to_s(filename)
    def to_s(io)
      ::embed_mustache({{ filename }}, "io", self)
    end
  end
end
