require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Sprite::Builder do

  context "configuration parsing" do
    before(:all) do
      @sprite = Sprite::Builder.from_config("resources/configs/config-test.yml")
    end 
    
    it "should load the settings keys from file" do
      @sprite.config.keys.size.should == 9
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

    it "'style_output_path:' setting should default to 'stylesheets/sprites'" do
      @sprite.config['style_output_path'].should == "stylesheets/sprites"
    end

    it "'image_output_path:' setting should default to 'images/sprites/'" do
      @sprite.config['image_output_path'].should == "images/sprites/"
    end

    it "'image_source_path:' setting should default to 'images/'" do
      @sprite.config['image_source_path'].should == "images/"
    end

    it "'public_path:' setting should default to 'public/'" do
      @sprite.config['public_path'].should == "public/"
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
  
end