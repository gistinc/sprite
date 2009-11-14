require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Sprite::Builder do

  context "Configuration Parsing" do
    before(:all) do
      @sprite = Sprite::Builder.new("resources/configs/full_config.yml")
    end
    
    it "should load the settings keys from file" do
      @sprite.config.keys.size.should == 2
    end
    
    it "should glob the files together" do
      @sprite.config["images"].first["sources"].size.should == 30
    end
    
  end
  
end