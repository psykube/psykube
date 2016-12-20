require "yaml"

class Psykube::Kubernetes::Deployment::Spec
  YAML.mapping(
    replicas: Int32 | Nil,
    selector: Selector,
    template: Template,
    strategy: Strategy | Nil,
    min_ready_seconds: {type: Int32, nilable: true, key: "minReadySeconds"},
    revision_history_limit: {type: Int32, nilable: true, key: "revisionHistoryLimit"},
    paused: Bool | Nil,
    rollback_to: {type: RollbackTo, key: "rollbackTo", nilable: true}
  )

  def initialize(name : String)
    @selector = Selector.new(name)
    @template = Template.new(name)
  end
end

require "./spec/*"
