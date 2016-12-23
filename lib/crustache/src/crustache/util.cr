# :nodoc:
module Crustache::Util
  ESCAPE = {
    '&' => "&amp;",
    '<' => "&lt;",
    '>' => "&gt;",
    '"' => "&quot;",
    '\'' => "&apos;",
  }

  # Since Crystal v0.13.0, `HTML.escape` escapes too many characters, it breaks
  # Mustache spec compatibility. This utility method can keep it.
  def self.escape(str, io)
    str.each_char do |char|
      io << ESCAPE.fetch(char, char)
    end
  end
end
