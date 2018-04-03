module Psykube::CLI::Commands::KubectlContextFlag
  private macro included
    define_flag context,
                description: "The context to use when invoking kubectl.",
                short: c
  end

  private def context
    flags.context || actor.context
  end
end
