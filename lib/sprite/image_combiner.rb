module Sprite
  class ImageCombiner
    def initialize
      # avoid loading rmagick till the last possible moment
      require 'rmagick'
    end
    
    def composite_images(dest_image, src_image, x, y)
      width = [src_image.columns + x, dest_image.columns].max
      height = [src_image.rows + y, dest_image.rows].max
      image = Magick::Image.new(width, height)
      image.opacity = Magick::MaxRGB

      image.composite!(dest_image, 0, 0, Magick::OverCompositeOp)
      image.composite!(src_image, x, y, Magick::OverCompositeOp)
      image
    end


    # Image Utility Methods
    def get_image(image_filename)
      image = Magick::Image::read(image_filename).first
    end

    def image_properties(image)
      {:name => File.basename(image.filename).split('.')[0], :width => image.columns, :height => image.rows}
    end

  end
end