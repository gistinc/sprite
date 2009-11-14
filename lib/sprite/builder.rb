module Sprite
  class Builder  
    DEFAULT_CONFIG_PATH = 'config/sprite.yml'
    DEFAULT_IMAGE_PATH = 'public/images/'
    DEFAULT_FILE_PATH = 'tmp/sprite.css'
    
    attr_reader :config
    attr_reader :images

    def initialize(config = nil, images = nil)
      results = config_results

      # use the override
      if config.is_a?(Hash)
        @config = config
      else
        @config = config["config"] || {}
      end
      
      # set defaults
      set_config_defaults

      # default image list
      if images.is_a?(Array)
        @images = images
      else
        @images = config["images"] || []
      end
      
      # process images
      process_image_settings
    end
  
    def build
      @output = {}
    
      # build up config
      @image_path = sprite_config['config']['base_image_path'] ? Sprite.root+"/"+sprite_config['config']['base_image_path']+"/" : DEFAULT_IMAGE_PATH
      @file_path = sprite_config['config']['output_file'] ? Sprite.root+"/"+sprite_config['config']['output_file'] : DEFAULT_FILE_PATH
    
      # create images
      sprite_config['images'].each do |configuration|
        output_image(configuration)
      end
    
      # write css
      output_css(sprite_config)
    end
  
    def output_image(configuration)
      results = []
      sources = configuration['sources'].to_a

      dest = configuration['target'] || sources[0].gsub(/\./,"_sprite.")
      spaced_by = configuration['spaced_by'] || 0
      
      combiner = ImageCombiner.new
      
      dest_image = combiner.get_image(sources.shift)
      results << combiner.image_properties(dest_image).merge(:x => 0, :y => 0)
      sources.each do |source|
        source_image = combiner.get_image(source)
        if configuration['align'].to_s == 'horizontal'
          x = dest_image.columns + spaced_by
          y = 0
        else
          x = 0
          y = dest_image.rows + spaced_by
        end
        results << combiner.image_properties(source_image).merge(:x => x, :y => y)
        dest_image = combiner.composite_images(dest_image, source_image, x, y)
      end
      @output[dest] = results
      dest_image.write(@image_path + dest)
    end
  
    def output_file(configuration)
      File.open(@file_path, 'w') do |f|
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
  
    # reads config config from the given path
    def read_config(path = nil)
      config_results = {}
      config_path = File.join(Sprite.root, path || DEFAULT_CONFIG_PATH)
      begin
        config_results = File.open(config_path) {|f| YAML::load(f)}
      rescue => e
        puts "Unable to read sprite config: #{Sprite.root+"/"+config_path}"
        puts e.to_s
      end
      config_results
    end
    
    # sets all the default values on the config
    def set_config_defaults
      @config['style']             ||= ''
      @config['output_path']       ||= 'public/sass/mixins/sprites'
      @config['image_output_path'] ||= 'public/images/sprite/'
      @config['source_path']       ||= ''
      @config['default_format']    ||= 'png'
      @config['class_separator']   ||= '_'
    end
    
    # expands out sources
    def process_image_config
      # cycle through image sources and expand out globs
      @images.each do |image|
        # find all the files
        image['sources'] = image['sources'].to_a.map do |source|
          Dir.glob(File.join(Sprite.root, @config['source_path'], source))
        end
        
        # remove the prefix on them
        new_sources = new_sources.flatten.map do |source|
          source.gsub!(Sprite.root, "")
        end
        
        image_config['sources'] = new_sources
      end
      
    rescue => e
      puts "Invalid sprite configuration syntax:"
      puts e.to_s
    end
    
  end
end