module Psykube::Version
  extend self

  macro build_version
    def version
      {{ env("TRAVIS_TAG") || "git-#{`git rev-parse --short HEAD`}" }}
    end
  end

  build_version
end
