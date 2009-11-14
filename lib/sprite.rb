# set up Sprite module
module Sprite  
  def self.root
    @root ||= nil

    # set the root to the framework setting (if not already set)
    @root ||= begin
      if defined?(Rails)
        Rails.root
      elsif defined?(Merb)
        Merb.root
      else
        "."
      end
    end
    @root
  end  
end

require 'sprite/builder'
require 'sprite/image_combiner'
