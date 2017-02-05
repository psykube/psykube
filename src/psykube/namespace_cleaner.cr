module Psykube::NamespaceCleaner
  def self.clean(namespace : String)
    namespace.sub(
      /^[^a-z0-9]+/i, ""
    ).sub(
      /[^a-z0-9]+$/i, ""
    ).gsub(
      /[^-a-z0-9]/i, "-"
    ).downcase
  end
end
