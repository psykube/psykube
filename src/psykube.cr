require "pyrite/versions/v1.9"
require "tempfile"
require "colorize"
require "digest"
require "yaml"
require "crustache"
require "openssl"

module Psykube
  {{ run "#{__DIR__}/parse_version.cr" }}

  LABELS = {
    "psykube" => "true",
  }

  alias StringMap = Hash(String, String)
  alias PortMap = Hash(String, Int32)
end

require "./psykube/concerns/*"
require "./psykube/*"
