require "./concerns/resource"
require "./shared/object_reference"

class Psykube::Kubernetes::Event
  Resource.definition("v1", "Event", {
    count:           Int32?,
    first_timestamp: Time?,
    involved_object: Shared::ObjectReference,
    last_timestamp:  Time?,
    message:         String?,
    reason:          String?,
    source:          Source?,
    type:            String?,
  })
end

require "./event/*"
