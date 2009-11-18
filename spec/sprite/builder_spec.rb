require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Sprite::Builder do

  context "configuration parsing" do
    before(:all) do
      @sprite = Sprite::Builder.from_config("resources/configs/config-test.yml")
    end 
    
    it "should load the settings keys from file" do
      @sprite.config.keys.size.should == 7
    end

    it "should load the image keys from file" do
      @sprite.images.size.should == 2
    end
    
    it "should expand any globs within the source paths" do
      @sprite.images.first["sources"].size.should == 30
    end
    
  end
  
  context "default settings" do
    before(:all) do
      @sprite = Sprite::Builder.new
    end
    
    it "'style:' setting should default to 'css'" do
      @sprite.config['style'].should == "css"
    end

    it "'output_path:' setting should default to 'public/stylesheets/sprites'" do
      @sprite.config['output_path'].should == "public/stylesheets/sprites"
    end

    it "'image_output_path:' setting should default to 'public/images/sprites/'" do
      @sprite.config['image_output_path'].should == "public/images/sprites/"
    end

    it "'source_path:' setting should default to 'public/images/'" do
      @sprite.config['source_path'].should == "public/images/"
    end

    it "'default_format:' setting should default to 'png'" do
      @sprite.config['default_format'].should == "png"
    end

    it "'sprites_class:' setting should default to 'sprites'" do
      @sprite.config['sprites_class'].should == "sprites"
    end

    it "'class_separator:' setting should default to '-'" do
      @sprite.config['class_separator'].should == "-"
    end    
  end
  
  context "generate android icon sprites" do
    before(:all) do
      clear_output
      @sprite = Sprite::Builder.from_config("resources/configs/android-icons.yml")
      @sprite.build
    end
    
    it "should generate android.png" do
      File.exists?("#{Sprite.root}/output/images/sprites/android-icons.png").should be_true
    end
    
    it "should generate android-icons.css" do
      File.exists?("#{Sprite.root}/output/stylesheets/android-icons.css").should be_true
    end
    
    context "sprite result image" do
      before(:all) do
        combiner = Sprite::ImageCombiner.new
        @result_image = combiner.get_image("#{Sprite.root}/output/images/sprites/android-icons.png")
        @result_properties = combiner.image_properties(@result_image)
      end
      
      it "should be 2890x48" do
        @result_properties[:width].should == 48
        @result_properties[:height].should == 2890
      end
    end
    
    context "sprite result styles" do
      before(:all) do
        @styles = File.read("#{Sprite.root}/output/stylesheets/android-icons.css")
      end
      
      it "should have some styles in it" do
        @styles.should_not be_nil
      end
    end
  end
  
end