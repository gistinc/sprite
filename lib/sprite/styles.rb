module Sprite::Styles
  GENERATORS = {
    "css" => "CssGenerator",
    "sass" => "SassGenerator",
    'sass_mixin' => "SassMixinGenerator"
  }
  
  def self.get(config)
    const_get(GENERATORS[config])
  rescue
    CssGenerator
  end
  
  # renders standard css style rules
  class CssGenerator
    def initialize(builder)
      @builder = builder
    end
    
    def generate(sprite_files)
      output = ""
      
      # set up class_name to append to each rule
      sprites_class = @builder.config['sprites_class'] ? ".#{@builder.config['sprites_class']}" : ""
      
      # write stylesheet file to disk
      sprite_files.each do |sprite_file, sprites|
        sprites.each do |sprite|
          output << "#{sprites_class}.#{sprite[:group]}#{@builder.config['class_separator']}#{sprite[:name]} {\n"
          output << "  background: url('/#{@builder.config['image_output_path']}#{sprite_file}') no-repeat #{sprite[:x]}px #{sprite[:y]}px;\n"
          output << "  width: #{sprite[:width]}px;\n"
          output << "  height: #{sprite[:height]}px;\n"
          output << "}\n"
        end
      end
      
      output
    end
    
    def extension
      "css"
    end
  end
  
  # renders standard sass rules
  class SassGenerator
    def initialize(builder)
      @builder = builder
    end

    def generate(sprite_files)
      output = ""
      
      # set up class_name to append to each rule
      sprites_class = @builder.config['sprites_class'] ? ".#{@builder.config['sprites_class']}" : ""
      
      output << ".#{sprites_class}"
      sprite_files.each do |sprite_file, sprites|
        sprites.each do |sprite|
          output << "  &.#{sprite[:group]}#{@builder.config['class_separator']}#{sprite[:name]}\n"
          output << "    background: url('/#{@builder.config['image_output_path']}#{sprite_file}') no-repeat #{sprite[:x]}px #{sprite[:y]}px\n"
          output << "    width: #{sprite[:width]}px\n"
          output << "    height: #{sprite[:height]}px\n"
          output << "\n"
        end
      end
      
      output
    end
    
    def extension
      "sass"
    end
  end
  
  # renders a yml file that is parsed by a sass extension
  class SassMixinGenerator
    def initialize(builder)
      @builder = builder
    end

    def generate(output)
      ""
    end
    
    def extension
      "yml"
    end
    
  end


end