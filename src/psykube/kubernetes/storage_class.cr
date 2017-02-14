require "./concerns/resource"

class Psykube::Kubernetes::StorageClass
  include Resource
  definition("storage.k8s.io/v1beta1", "StorageClass", {
    parameters:  Hash(String, String)?,
    provisioner: String,
  })
end
