require 'fileutils'
module Sprite
  class Builder  
    DEFAULT_CONFIG_PATH = 'config/sprite.yml'
    
    attr_reader :config
    attr_reader :images
    attr_reader :output
    
    def self.from_config(path = nil) 
      results = {}
      config_path = File.join(Sprite.root, path || DEFAULT_CONFIG_PATH)
      
      # read configuration
      if File.exists?(config_path) 
        begin
          results = File.open(config_path) {|f| YAML::load(f)} || {}
        rescue => e
          puts "Error reading sprite config: #{config_path}"
          puts e.to_s
        end
      end

      new(results["config"], results["images"])
    end

    def initialize(config = nil, images = nil)
      @config = config || {}
      set_config_defaults
      
      @images = images || []
      set_image_defaults
      expand_image_paths
      
      # initialize output
      @output = {}
    end
  
    def build    
      @output = {}
      
      if images.size > 0
        # create images
        images.each do |image|
          output_image(image)
        end
    
        # write css
        output_file
      end
    end
    
    protected
    def output_image(image)
      results = []
      sources = image['sources'].to_a
      return unless sources.length > 0
      
      name = image['name']
      spaced_by = image['spaced_by'] || 0
      
      combiner = ImageCombiner.new
      
      dest_image = combiner.get_image(sources.shift)
      results << combiner.image_properties(dest_image).merge(:x => 0, :y => 0)
      sources.each do |source|
        source_image = combiner.get_image(source)
        if image['align'].to_s == 'horizontal'
          x = dest_image.columns + spaced_by
          y = 0
        else
          x = 0
          y = dest_image.rows + spaced_by
        end
        results << combiner.image_properties(source_image).merge(:x => x, :y => y, :group => name)
        dest_image = combiner.composite_images(dest_image, source_image, x, y)
      end
      
      # set up path
      path = image_output_path(name, image['format'] || config["default_format"])
      FileUtils.mkdir_p(File.dirname(path))
      
      # write sprite image file to disk
      dest_image.write(path)
      @output[name] = results
    end

    def output_file
      # set up path
      path = style_output_path("css")
      FileUtils.mkdir_p(File.dirname(path))
      
      # set up class_name to append to each rule
      sprites_class = config['sprites_class'] ? ".#{config['sprites_class']}" : ""
      
      # write stylesheet file to disk
      File.open(path, 'w') do |f|
        @output.each do |dest, results|
          results.each do |result|
            f.puts "#{sprites_class}.#{result[:group]}#{config['class_separator']}#{result[:name]} {"
            f.puts "  background: url('/#{config['image_output_path']}#{dest}') no-repeat #{result[:x]}px #{result[:y]}px;"
            f.puts "  width: #{result[:width]}px;"
            f.puts "  height: #{result[:height]}px;"
            f.puts "}"
          end
        end
      end
    end
    
    # get the disk path for the style output file
    def style_output_path(file_ext)
      path = config['style_output_path']
      unless path.include?(".#{file_ext}")
        path = "#{path}.#{file_ext}"
      end
      public_path(path)
    end
    
    # get the disk path for a location within the image output folder
    def image_output_path(name, format)
      path_parts = []
      path_parts << chop_trailing_slash(config['image_output_path'])
      path_parts << "#{name}.#{format}"
      public_path(File.join(*path_parts))
    end
    
    # get the disk path for a location within the public folder (if set)
    def public_path(location)
      path_parts = []
      path_parts << Sprite.root
      path_parts << chop_trailing_slash(config['public_path']) if config['public_path'] and config['public_path'].length > 0
      path_parts << location
      
      File.join(*path_parts)
    end
    
    # chop off the trailing slash on a directory path (if it exists)
    def chop_trailing_slash(path)
      path = path[0...-1] if path[-1] == File::SEPARATOR
      path
    end
    
    # sets all the default values on the config
    def set_config_defaults
      @config['style']              ||= 'css'
      @config['style_output_path']        ||= 'stylesheets/sprites'
      @config['image_output_path']  ||= 'images/sprites/'
      @config['image_source_path']        ||= 'images/'
      @config['public_path']        ||= 'public/'
      @config['default_format']     ||= 'png'
      @config['class_separator']    ||= '-'
      @config["sprites_class"]      ||= 'sprites'
    end
    
    # if no image configs are detected, set some intelligent defaults
    def set_image_defaults
      return unless @images.size == 0
      
      sprites_path = File.join(Sprite.root, config['public_path'], config['image_source_path'], "sprites")
      
      if File.exists?(sprites_path)
        Dir.glob(File.join(sprites_path, "*")) do |dir|
          next unless File.directory?(dir)
          source_name = File.basename(dir)

          # default to finding all png, gif, jpg, and jpegs within the directory
          images << {
            "name" => source_name,
            "sources" => [
              File.join("sprites", source_name, "*.png"),
              File.join("sprites", source_name, "*.gif"),
              File.join("sprites", source_name, "*.jpg"),
              File.join("sprites", source_name, "*.jpeg"),
            ]
          }
        end
      end
      
    end
    
    # expands out sources, taking the Glob paths and turning them into separate entries in the array
    def expand_image_paths
      # cycle through image sources and expand out globs
      @images.each do |image|
        # expand out all the globs
        image['sources'] = image['sources'].to_a.map{ |source|
          Dir.glob(File.join(Sprite.root, config['public_path'], @config['image_source_path'], source))
        }.flatten.compact
      end
    end
    
  end
end