module Sprite
  class Runner
    
    attr_accessor :options
    def initialize(args)
      self.options = set_options(args)
    end
    
    def set_options(args)
      opts = {}
      # TODO
      # edit options with passed in args
      opts
    end
    
    # run sprite creator
    def run!
      begin
        Sprite::Builder.from_config(options[:path]).build
      # rescue Exception => e
      #   # catch errors
      #   puts "ERROR"
      #   puts e
      #   return 1
      end
      0
    end
    
  end
end