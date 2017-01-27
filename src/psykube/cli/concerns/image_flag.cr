module Psykube::Commands::ImageFlag
  private macro included
    define_flag image, description: "The image to push."
  end

  def image
    flags.image || generator.image
  end
end
