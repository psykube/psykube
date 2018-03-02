require "pyrite/versions/v1.9.3"
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
  alias VolumeMap = Hash(String, V1::Manifest::Volume | String)

  def self.current_docker_user
    {% if env("EXCLUDE_DOCKER") != "true" %}
      `#{Psykube::CLI::Commands::Docker.bin} info`.lines.find(&.=~ /^Username/).try(&.split(":")[1]?).to_s.strip
    {% else %}
      nil
    {% end %}
  end

  def self.current_kubectl_context
    `#{Psykube::CLI::Commands::Kubectl.bin} config current-context`.strip
  end
end

require "./psykube/concerns/*"
require "./psykube/*"
