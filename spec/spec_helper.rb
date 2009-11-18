require 'rubygems'
require 'spec/autorun'
require 'date'
require 'fileutils'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "/../lib"))

require 'sprite'

# set Sprite.root to be this spec/ folder
Sprite.module_eval{ @root = File.dirname(__FILE__) }

Spec::Runner.configure do |config|
  
  module SpriteSpecHelpers
    def clear_output
      FileUtils.rm_rf("#{Sprite.root}/output")
    end
  end

  config.include(SpriteSpecHelpers)
  config.before(:all) do    
  end
  
end
