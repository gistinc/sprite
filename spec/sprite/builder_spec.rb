require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Sprite::Builder do

  context "configuration parsing" do
    before(:all) do
      @sprite = Sprite::Builder.from_config("resources/configs/full_config.yml")
    end
    
    it "should load the settings keys from file" do
      @sprite.config.keys.size.should == 6
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

    it "'image_output_path:' setting should default to 'public/images/sprites/" do
      @sprite.config['image_output_path'].should == "public/images/sprites/"
    end

    it "'source_path:' setting should default to 'public/images/" do
      @sprite.config['source_path'].should == "public/images/"
    end
        
    
  end
  
end