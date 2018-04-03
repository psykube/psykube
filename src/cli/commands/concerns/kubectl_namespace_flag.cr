module Psykube::CLI::Commands::KubectlNamespaceFlag
  private macro included
    define_flag namespace,
                description: "The namespace to use when invoking kubectl.",
                short: n
  end

  private def namespace
    actor.namespace
  end
end
