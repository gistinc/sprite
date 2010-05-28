require 'fileutils'
module Sprite
  class Builder  
    DEFAULT_CONFIG_PATH = 'config/sprite.yml'
    
    attr_reader :config
    attr_reader :images
    
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

      # initialize datestamp
      @datestamp_query = "?#{Time.now.to_i}" if @config["add_datestamps"]
      
      # initialize sprite files
      @sprite_files = {}
    end
  
    def build    
      @sprite_files = {}
      
      if images.size > 0
        # create images
        images.each do |image|
          write_image(image)
        end
    
        if @sprite_files.values.length > 0
          # write css
          write_styles
        end
      end
    end
    
    protected
    def write_image(image)
      results = []
      sources = image['sources'].to_a.sort
      return unless sources.length > 0
      
      name = image['name']
      format = image['format'] || config["default_format"]
      spaced_by = image['spaced_by'] || config["default_spacing"] || 0
      
      combiner = ImageCombiner.new
      
      dest_image = combiner.get_image(sources.shift)
      results << combiner.image_properties(dest_image).merge(:x => 0, :y => 0, :group => name)
      sources.each do |source|
        source_image = combiner.get_image(source)
        if image['align'].to_s == 'horizontal'
          x = dest_image.columns + spaced_by
          y = 0
          align = "horizontal"
        else
          x = 0
          y = dest_image.rows + spaced_by
          align = "vertical"
        end
        results << combiner.image_properties(source_image).merge(:x => -x, :y => -y, :group => name, :align => align)
        dest_image = combiner.composite_images(dest_image, source_image, x, y)
      end
      
      # set up path
      path = image_output_path(name, format)
      FileUtils.mkdir_p(File.dirname(path))
      
      # write sprite image file to disk
      dest_image.write(path)
      @sprite_files["#{name}.#{format}#{@datestamp_query}"] = results
    end
    
    def write_styles
      style = Styles.get(config["style"]).new(self)
      
      # use the absolute style output path to make sure we have the directory set up
      path = style_output_path(style.extension, false)
      FileUtils.mkdir_p(File.dirname(path))
      
      # send the style the relative path
      style.write(style_output_path(style.extension, true), @sprite_files)
    end
    
    # sets all the default values on the config
    def set_config_defaults
      @config['style']              ||= 'css'
      @config['style_output_path']  ||= 'stylesheets/sprites'
      @config['image_output_path']  ||= 'images/sprites/'
      @config['image_source_path']  ||= 'images/'
      @config['public_path']        ||= 'public/'
      @config['default_format']     ||= 'png'
      @config['class_separator']    ||= '-'
      @config["sprites_class"]      ||= 'sprites'
      @config["default_spacing"]    ||= 0
      
      unless @config.has_key?("add_datestamps")
        @config["add_datestamps"] = true
      end
    end
    
    # if no image configs are detected, set some intelligent defaults
    def set_image_defaults
      return unless @images.size == 0
      
      sprites_path = image_source_path("sprites")
      
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
          Dir.glob(image_source_path(source))
        }.flatten.compact
      end
    end
    
    # get the disk path for the style output file
    def style_output_path(file_ext, relative = false)
      path = config['style_output_path']
      unless path.include?(".#{file_ext}")
        path = "#{path}.#{file_ext}"
      end
      public_path(path, relative)
    end
    
    # get the disk path for a location within the image output folder
    def image_output_path(name, format, relative = false)
      path_parts = []
      path_parts << chop_trailing_slash(config['image_output_path']) if path_present?(config['image_output_path'])
      path_parts << "#{name}.#{format}"
      public_path(File.join(*path_parts), relative)
    end
    
    # get the disk path for an image source file
    def image_source_path(location, relative = false)
      path_parts = []
      path_parts << chop_trailing_slash(config["image_source_path"]) if path_present?(config['image_source_path'])
      path_parts << location
      public_path(File.join(*path_parts), relative)
    end
    
    # get the disk path for a location within the public folder (if set)
    def public_path(location, relative = false)
      path_parts = []
      path_parts << Sprite.root unless relative
      path_parts << chop_trailing_slash(config['public_path']) if path_present?(config['public_path'])
      path_parts << location
      
      File.join(*path_parts)
    end
        
    # chop off the trailing slash on a directory path (if it exists)
    def chop_trailing_slash(path)
      path = path[0...-1] if path[-1] == File::SEPARATOR
      path
    end
    
    # check if the path is set
    def path_present?(path)
      path.to_s.strip != ""
    end
  end
end
