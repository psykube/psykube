require "./concerns/resource"

class Psykube::Kubernetes::Endpoint
  Resource.definition("v1", "Endpoint", {
    subsets: Array(Subset),
  })
end

require "./endpoint/*"
