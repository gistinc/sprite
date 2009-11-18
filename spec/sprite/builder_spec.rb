require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Sprite::Builder do
  
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