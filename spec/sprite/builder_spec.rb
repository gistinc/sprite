require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Sprite::Builder do
  
  context "should generate vertical android icon sprites" do
    before(:all) do
      @sprite = Sprite::Builder.from_config("resources/configs/android-icons.yml")
      @sprite.config["style_output_path"] = "output/android_vertical/stylesheets/android-icons"
      @sprite.config["image_output_path"] = "output/android_vertical/images/sprites/"
      @sprite.images.first["align"] = "vertical"
      @sprite.build
      
      @output_path = "#{Sprite.root}/output/android_vertical"
    end
    
    context "and the sprite result image" do
      before(:all) do
        combiner = Sprite::ImageCombiner.new
        @result_image = combiner.get_image("#{@output_path}/images/sprites/android-icons.png")
        @result_properties = combiner.image_properties(@result_image)
      end
      
      it "should be 48x2890" do
        "#{@result_properties[:width]}x#{@result_properties[:height]}".should == "48x2890"
      end
    end
    
    context "and the sprite result styles" do
      before(:all) do
        @styles = File.read("#{@output_path}/stylesheets/android-icons.css")
      end
      
      it "should have some styles in it" do
        @styles.should_not be_nil
        @styles.strip.should_not == ""
      end
    end
  end

  context "should generate horizontal android icon sprites" do
    before(:all) do
      @sprite = Sprite::Builder.from_config("resources/configs/android-icons.yml")
      @sprite.config["style_output_path"] = "output/android_horizontal/stylesheets/android-icons"
      @sprite.config["image_output_path"] = "output/android_horizontal/images/sprites/"
      @sprite.images.first["align"] = "horizontal"
      @sprite.build
      
      @output_path = "#{Sprite.root}/output/android_horizontal"
    end
    
    context "and the sprite result image" do
      before(:all) do
        combiner = Sprite::ImageCombiner.new
        @result_image = combiner.get_image("#{@output_path}/images/sprites/android-icons.png")
        @result_properties = combiner.image_properties(@result_image)
      end
      
      it "should be 2890x48" do
        "#{@result_properties[:width]}x#{@result_properties[:height]}".should == "2890x48"
      end
    end
    
    context "and sprite result styles" do
      before(:all) do
        @styles = File.read("#{@output_path}/stylesheets/android-icons.css")
      end
      
      it "should have some styles in it" do
        @styles.should_not be_nil
        @styles.strip.should_not == ""
      end
    end
  end


end