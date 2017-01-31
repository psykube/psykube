module Psykube::Commands::ImageFlag
  private macro included
    define_flag image, description: "The image to push."
  end

  def image
    image_flag || generator.image
  end
end
