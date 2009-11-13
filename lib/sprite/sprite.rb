require 'RMagick'

class Sprite  
  CONFIG_PATH = RAILS_ROOT + '/config/'
  DEFAULT_IMAGE_PATH = RAILS_ROOT + '/public/images/'
  CSS_OUTPUT = RAILS_ROOT + '/tmp/css_sprite.css'
  
  def initialize
    @image_path = DEFAULT_IMAGE_PATH
    @config_files = Dir.glob("#{CONFIG_PATH}/css_sprite*.yml")
  end
  
  def build
    @config_files.each do |config_file|
      @output = {}
      sprite_config = File.open(config_file) {|f| YAML::load(f)}
      @image_path = (sprite_config['config']['base_directory'])?RAILS_ROOT+"/"+sprite_config['config']['base_directory']+"/":DEFAULT_IMAGE_PATH
      @css_output = (sprite_config['config']['css_output'])?RAILS_ROOT+"/"+sprite_config['config']['css_output']:CSS_OUTPUT
      sprite_config['images'].each do |configuration|
         output_image(configuration)
      end
      output_css(sprite_config)
    end
  end
  
  def output_image(configuration)
    results = []
    sources = configuration['sources'].collect {|source| Dir.glob(@image_path+source)}.flatten
    dest = configuration['target'] || sources[0].gsub(/\./,"_sprite.")
    spaced_by = configuration['spaced_by'] || 0
    dest_image = get_image(sources.shift)
    results << image_properties(dest_image).merge(:x => 0, :y => 0)
    sources.each do |source|
      source_image = get_image(source)
      if configuration['align'] == 'horizontal'
        gravity = Magick::EastGravity
        x = dest_image.columns + spaced_by
        y = 0
      else
        gravity = Magick::SouthGravity
        x = 0
        y = dest_image.rows + spaced_by
      end
      results << image_properties(source_image).merge(:x => x, :y => y)
      dest_image = composite_images(dest_image, source_image, x, y)
    end
    @output[dest] = results
    dest_image.write(@image_path + dest)
  end
  
  def output_css(configuration)
    File.open(@css_output, 'w') do |f|
      @output.each do |dest, results|
        results.each do |result|
          f.puts ".#{result[:name]}"
          f.puts "\tbackground: url('/images/#{dest}') no-repeat #{result[:x]}px #{result[:y]}px;"
          f.puts "\twidth: #{result[:width]}px;"
          f.puts "\theight: #{result[:height]}px;"
          f.puts ""
        end
      end
    end
  end
  
  def composite_images(dest_image, src_image, x, y)
    width = [src_image.columns + x, dest_image.columns].max
    height = [src_image.rows + y, dest_image.rows].max
    image = Magick::Image.new(width, height)
    image.opacity = Magick::MaxRGB
    
    image.composite!(dest_image, 0, 0, Magick::OverCompositeOp)
    image.composite!(src_image, x, y, Magick::OverCompositeOp)
    image
  end
  
  def get_image(image_filename)
    image = Magick::Image::read(image_filename).first
  end
  
  def image_properties(image)
    {:name => File.basename(image.filename).split('.')[0], :width => image.columns, :height => image.rows}
  end
    
end
