module Sprite::Sass::Extensions
  def sprite_background(group, image)
    sprite = sprite_data(group, image)
    # TODO
    ""
  end

  def sprite_width(group, image)
    sprite = sprite_data(group, image)
    # TODO
    ""
  end
  
  def sprite_height(group, image)
    sprite = sprite_data(group, image)
    # TODO
    ""
  end
  
  protected
  def sprite_data(group, image)
    unless @__sprite_data
      @__sprite_data = {
        "group_name" => {
          "image_name" => {
            :width => "",
            :height => "",
            :group => "dkajsdfk",
            :x => "",
            :y => ""
          }
        }
      }
    end
    
    group_data = @__sprite_data[group]
    if group_data
      return group_data[image]
    else
      nil
    end
  end
  
end

if defined?(Sass)
  module Sass::Script::Functions
    include Sprite::Sass::Extensions
  end
end