module Crustache
  class Engine
    def initialize(@fs : FileSystem); end

    def initialize(basedir, cache = false)
      @fs = ViewLoader.new basedir, cache
    end

    # It renders a template loaded from `filename` with `model`
    # and it returns rendered string.
    # If `filename` is not found, it returns `nil`, but it dosen't raise an error.
    def render(filename : String, model)
      @fs.load(filename).try{|tmpl| self.render tmpl, model}
    end

    def render(filename : String, model, io)
      @fs.load(filename).try{|tmpl| self.render tmpl, model, io}
    end

    # It is a strict version `Engine#render`.
    # If `filename` is not found, it raise an error.
    def render!(filename : String, model)
      @fs.load!(filename).try{|tmpl| self.render tmpl, model}
    end

    def render!(filename : String, model, io)
      @fs.load!(filename).try{|tmpl| self.render tmpl, model, io}
    end

    def render(tmpl, model)
      Crustache.render tmpl, model, @fs
    end

    def render(tmpl, model, io)
      Crustache.render tmpl, model, @fs, io
    end
  end
end
