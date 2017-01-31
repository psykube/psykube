module Psykube::Commands::KubectlClusterArg
  private macro included
    define_argument cluster,
                    description: "The cluster to use when invoking commands.",
                    required: true
  end

  private def cluster_name
    arguments.cluster
  end
end
