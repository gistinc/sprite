module Sprite
  class Builder  
    DEFAULT_CONFIG_PATH = 'config/sprite.yml'
    DEFAULT_IMAGE_PATH = 'public/images/'
    DEFAULT_FILE_PATH = 'tmp/sprite.css'
    
    def initialize(settings = nil)
      @image_path = DEFAULT_IMAGE_PATH
    
      if settings.is_a?(Hash)
        @sprite_config = settings
      else
        @sprite_config = read_sprite_config(settings)
      end
    end
  
    def build
      @output = {}
    
      # build up settings
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
      sources = configuration['sources'].collect {|source| Dir.glob(@image_path+source)}.flatten
      dest = configuration['target'] || sources[0].gsub(/\./,"_sprite.")
      spaced_by = configuration['spaced_by'] || 0
      dest_image = ImageUtil.get_image(sources.shift)
      results << ImageUtil.image_properties(dest_image).merge(:x => 0, :y => 0)
      sources.each do |source|
        source_image = ImageUtil.get_image(source)
        if configuration['align'] == 'horizontal'
          gravity = Magick::EastGravity
          x = dest_image.columns + spaced_by
          y = 0
        else
          gravity = Magick::SouthGravity
          x = 0
          y = dest_image.rows + spaced_by
        end
        results << ImageUtil.image_properties(source_image).merge(:x => x, :y => y)
        dest_image = ImageUtil.composite_images(dest_image, source_image, x, y)
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
  
    # reads config settings from the given path
    def read_sprite_config(path = nil)
      config_path = File.join(Sprite.root, path || DEFAULT_CONFIG_PATH)
      begin
        config = File.open(config_path) {|f| YAML::load(f)}    
      rescue => e
        puts "Unable to read sprite config: #{Sprite.root+"/"+config_path}"
        puts e.to_s
      end
      config
    rescue
    end
  end
end