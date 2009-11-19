module Sprite
  module Styles
    # renders a yml file that is later parsed by a sass extension when generating the mixins
    class SassMixinGenerator
      def initialize(builder)
        @builder = builder
      end
      
      def write(path, sprite_files)    
        # write the sass mixins to disk
        File.open(File.join(Sprite.root, path), 'w') do |f|
          add_else = false

          f.puts "= sprite(!group_name, !image_name, !offset=0)"
          sprite_files.each do |sprite_file, sprites|
            sprites.each do |sprite|
              
              f << "  @"
              if add_else
                f << "else "
              end
              add_else = true
              #{sprite[:x]}px #{sprite[:y]}px
              
              if sprite[:align] == 'horizontal'
                background_offset = "\#{#{sprite[:x]}+!offset}px #{sprite[:y]}px"
              else
                background_offset = "#{sprite[:x]}px \#{#{sprite[:y]}+!offset}px"
              end
              
              f.puts %{if !group_name == "#{sprite[:group]}" and !image_name == "#{sprite[:name]}"}
              f.puts "    background: url('/#{@builder.config['image_output_path']}#{sprite_file}') no-repeat #{background_offset}"
              f.puts "    width: #{sprite[:width]}px"
              f.puts "    height: #{sprite[:height]}px"
            end
          end
        end
      end

      def extension
        "sass"
      end
  
    end
  end
end