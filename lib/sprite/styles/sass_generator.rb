module Sprite
  module Styles

    # renders standard sass rules
    class SassGenerator
      def initialize(builder)
        @builder = builder
      end

      def write(path, sprite_files)
        @level = 0

        File.open(File.join(Sprite.root, path), 'w') do |f|
          if @builder.config['sprites_class']
            f.puts ".#{@builder.config['sprites_class']}"
            @level += 1
          end
          
          sprite_files.each do |sprite_file, sprites|
            sprites.each do |sprite|
              f.puts sass_line("&.#{sprite[:group]}#{@builder.config['class_separator']}#{sprite[:name]}")
              @level += 1
              f.puts sass_line("background: url('/#{@builder.config['image_output_path']}#{sprite_file}') no-repeat #{sprite[:x]}px #{sprite[:y]}px")
              f.puts sass_line("width: #{sprite[:width]}px")
              f.puts sass_line("height: #{sprite[:height]}px")
              f.puts sass_line("")
              @level -= 1
            end
          end
        end
      end
      
      # write sass output with correct tab spaces prepended
      def sass_line(sass)
        "#{'  '*@level}#{sass}"
      end
  
      def extension
        "sass"
      end
    end
  end
end