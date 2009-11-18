require File.dirname(__FILE__) + '/../spec_helper'

describe Sprite::ImageCombiner do
  before(:all) do
    # build a sprite object with empty config
    @combiner = Sprite::ImageCombiner.new
    
    @image_paths = {
      :good => "#{Sprite.root}/resources/images/topics/good-topic.gif",
      :mid => "#{Sprite.root}/resources/images/topics/mid-topic.gif"
    }
  end
  
  context "image handling" do
    context "get_image" do
      it "should get a image" do
        @combiner.get_image(@image_paths[:good]).class.should == Magick::Image
      end
    end
  
    context "image_properties" do
      it "should get image properties" do
        image = @combiner.get_image(@image_paths[:good])
        @combiner.image_properties(image).should == {:name => 'good-topic', :width => 20, :height => 19}
      end
    end
  
    context "composite_images" do
      it "should composite two images into one horizontally" do
        image1 = @combiner.get_image(@image_paths[:good])
        image2 = @combiner.get_image(@image_paths[:mid])
        image = @combiner.composite_images(image1, image2, image1.columns, 0)
        @combiner.image_properties(image).should == {:name => nil, :width => 40, :height => 19}
      end
    
      it "should composite two images into one verically" do
        image1 = @combiner.get_image(@image_paths[:good])
        image2 = @combiner.get_image(@image_paths[:mid])
        image = @combiner.composite_images(image1, image2, 0, image1.rows)
        @combiner.image_properties(image).should == {:name => nil, :width => 20, :height => 38}
      end
    end
  end
end