module Psykube::GitData
  private def ci_branch
    ENV["TRAVIS_BRANCH"]? || ENV["CIRCLE_BRANCH"]? || ENV["GIT_BRANCH"]? || (ENV["CI_COMMIT_TAG"]? ? nil : ENV["CI_COMMIT_REF_NAME"]?)
  end

  private def ci_sha
    ENV["TRAVIS_COMMIT"]? || ENV["CIRCLE_SHA1"]? || ENV["GIT_COMMIT"]? || ENV["CI_COMMIT_SHA"]?
  end

  private def ci_tag
    ENV["TRAVIS_TAG"]? || ENV["CIRCLE_TAG"]? || ENV["GIT_TAG_NAME"]? || ENV["CI_COMMIT_TAG"]?
  end

  private def git_branch
    ci_branch || maybe_nil(`git rev-parse --abbrev-ref HEAD`.strip)
  end

  private def git_sha
    ci_sha || maybe_nil(`git rev-parse HEAD`.strip)
  end

  private def git_tag
    ci_tag || maybe_nil(`git describe --exact-match --abbrev=0 --tags 2> /dev/null`.strip)
  end

  private def prefix
    cluster.prefix || manifest.prefix
  end

  private def maybe_nil(string : String)
    string.empty? ? nil : string
  end
end
