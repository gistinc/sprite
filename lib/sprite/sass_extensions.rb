module Sprite::Sass::Extensions
  def sprite_background(group, image)
    sprite = sprite_data(group, image)
    if sprite
      "url('#{sprite[:img]}') no-repeat #{sprite[:x]}px #{sprite[:y]}px"
    else
      ""
    end
  end

  def sprite_width(group, image)
    sprite = sprite_data(group, image)
    if sprite
      "#{sprite[:width]}px"
    else
      ""
    end
  end
  
  def sprite_height(group, image)
    sprite = sprite_data(group, image)
    if sprite
      "#{sprite[:height]}px"
    else
      ""
    end
  end
  
  protected
  def sprite_data(group, image)
    unless @__sprite_data
      
      # TODO: read template from !sprite_data
      sprite_data_path = "public/sass/sprites.yml"
      
      # figure out the site root
      root = "./"
      
      # read sprite data from yml
      @__sprite_data = File.open(File.join(root, sprite_data_path)) { |yf| YAML::load( yf ) }
    end
    
    group_data = @__sprite_data[group.to_s]
    if group_data
      return group_data[image.to_s]
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