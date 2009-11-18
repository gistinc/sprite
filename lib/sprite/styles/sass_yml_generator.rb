require 'yaml'
module Sprite
  module Styles
    # renders a yml file that is later parsed by a sass extension when generating the mixins
    class SassYmlGenerator
      def initialize(builder)
        @builder = builder
      end
      
      def write(path, sprite_files)        
        # build the yml file
        config_location = write_config(path, sprite_files)
        
        # write the sass mixins to disk
        File.open(File.join(Sprite.root, path), 'w') do |f|
          f.puts "!sprite_data = '#{config_location}'"
          f.puts ""
          f.puts "= sprite(!group_name, !image_name)"
          f.puts "  background= sprite_background(!group_name, !image_name)"
          f.puts "  width= sprite_width(!group_name, !image_name)"
          f.puts "  height= sprite_height(!group_name, !image_name)"
          f.puts ""
        end
      end
      
      # write the sprite configuration file (used by the yml extension)
      def write_config(path, sprite_files)
        # build a grouped hash with all the sprites in it
        result = {}
        sprite_files.each do |sprite_file, sprites|
          sprites.each do |sprite|
            if sprite[:group]
              result[sprite[:group]] ||= {}
              result[sprite[:group]][sprite[:name]] = sprite
            end
          end
        end
        
        # write the config yml to disk
        config_path = path.gsub(".sass", ".yml")
        File.open(File.join(Sprite.root, config_path), 'w') do |f|
          YAML.dump(result, f)
        end
        
        config_path
      end
      
      def extension
        "sass"
      end
  
    end
  end
end