require "./*"

module Psykube::Commands::KubectlAll
  private macro included
    include KubectlClusterArg
    include PsykubeFileFlag
    include KubectlContextFlag
    include KubectlNamespaceFlag
  end
end
