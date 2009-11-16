module Sprite
  class Runner
    
    attr_accessor :options
    def initialize(args)
      self.args = args
      self.options = {}
      parse(args)
    end
    
    def parse(args)
      # TODO: edit options with passed in args
    end
    
    # run sprite creator
    def run!
      # TODO
    end
    
  end
end