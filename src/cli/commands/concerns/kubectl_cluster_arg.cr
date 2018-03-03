module Psykube::CLI::Commands::KubectlClusterArg
  private macro included
    define_flag cluster,
                description: "The cluster to use when invoking commands."
  end

  private def cluster_name
    flags.cluster
  end
end
