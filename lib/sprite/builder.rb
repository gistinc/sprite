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
      begin
        results = File.open(config_path) {|f| YAML::load(f)} || {}
      rescue => e
        puts "Unable to read sprite config: #{Sprite.root+"/"+config_path}"
        puts e.to_s
      end
      
      new(results["config"], results["images"])
    end

    def initialize(config = nil, images = nil)
      @config = config || {}
      set_config_defaults
      
      @images = images || []
      expand_image_paths
      
      # freeze hashes
      @config = @config.dup.freeze
      @images = @images.dup.freeze

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
        results << combiner.image_properties(source_image).merge(:x => x, :y => y)
        dest_image = combiner.composite_images(dest_image, source_image, x, y)
      end
      @output[name] = results
      
      # set up path
      path = image_path(name, image['format'])
      FileUtils.mkdir_p(File.dirname(path))
      
      # write sprite image file to disk
      dest_image.write(path)
    end
    
    def output_file
      # set up path
      path = output_path("css")
      FileUtils.mkdir_p(File.dirname(path))
      
      # write stylesheet file to disk
      File.open(path, 'w') do |f|
        @output.each do |dest, results|
          results.each do |result|
            f.puts ".#{result[:name]}"
            f.puts "  background: url('/images/#{dest}') no-repeat #{result[:x]}px #{result[:y]}px;"
            f.puts "  width: #{result[:width]}px;"
            f.puts "  height: #{result[:height]}px;"
            f.puts ""
          end
        end
      end
    end
    
    protected
    
    def output_path(file_ext)
      "#{Sprite.root}/#{config['output_path']}.#{file_ext}"
    end
    
    def image_path(name, format)
      "#{Sprite.root}/#{config['image_output_path']}#{name}.#{format}"
    end
    
    # sets all the default values on the config
    def set_config_defaults
      @config['style']             ||= 'css'
      @config['output_path']       ||= 'public/stylesheets/sprites'
      @config['image_output_path'] ||= 'public/images/sprites/'
      @config['source_path']       ||= 'public/images/'
      @config['default_format']    ||= 'png'
      @config['class_separator']   ||= '_'
    end
    
    # expands out sources, taking the Glob paths and turning them into separate entries in the array
    def expand_image_paths
      # cycle through image sources and expand out globs
      @images.each do |image|
        # expand out all the globs
        image['sources'] = image['sources'].to_a.map{ |source|
          Dir.glob(File.join(Sprite.root, @config['source_path'], source))
        }.flatten.compact
      end
    end
    
  end
end