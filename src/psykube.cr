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

  ANNOTATIONS = {
    "psykube.io/whodunit"        => `whoami`.strip,
    "psykube.io/cause"           => ([PROGRAM_NAME] + ARGV.to_a).join(" "),
    "psykube.io/last-applied-at" => Time::Format::ISO_8601_DATE_TIME.format(Time.utc_now),
  }

  alias StringMap = Hash(String, String)
  alias PortMap = Hash(String, Int32)
end

require "./psykube/concerns/*"
require "./psykube/*"
