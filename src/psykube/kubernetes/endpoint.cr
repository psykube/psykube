require "./concerns/resource"

class Psykube::Kubernetes::Endpoint
  include Resource
  definition("v1", "Endpoint", {
    subsets: Array(Subset),
  })
end

require "./endpoint/*"
