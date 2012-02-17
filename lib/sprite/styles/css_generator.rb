module Sprite
  module Styles
    # renders standard css style rules
    class CssGenerator
      def initialize(builder)
        @builder = builder
      end
  
      def write(path, sprite_files)
        # set up class_name to append to each rule
        sprites_class = @builder.config['sprites_class'] ? ".#{@builder.config['sprites_class']}" : ""
    
        # write styles to disk
        File.open(File.join(Sprite.root, path), 'w') do |f|
          # write stylesheet file to disk
          sprite_files.each do |sprite_file, sprites|
            sprites.each do |sprite|
              f.puts "#{sprites_class}.#{sprite[:group]}#{@builder.config['class_separator']}#{sprite[:name]} {"
              f.puts "  background: url('/#{@builder.config['image_stylesheet_path']}#{sprite_file}') no-repeat #{sprite[:x]}px #{sprite[:y]}px;"
              f.puts "  width: #{sprite[:width]}px;"
              f.puts "  height: #{sprite[:height]}px;"
              f.puts "}"
            end
          end
        end      
      end
  
      def extension
        "css"
      end
    end
  end
end