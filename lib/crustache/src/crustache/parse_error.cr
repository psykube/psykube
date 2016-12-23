module Crustache
  class ParseError < Exception
    getter filename
    getter row

    def initialize(@msg : String, @filename : String, @row : Int32); super(message) end

    def message
      "#{@filename.inspect} line at #{@row}: #{@msg}"
    end
  end
end
