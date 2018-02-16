require "pyrite/versions/v1.9.3"
require "tempfile"
require "colorize"

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
end

require "./psykube/*"
