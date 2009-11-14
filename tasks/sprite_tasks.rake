require File.join(File.dirname(__FILE__), '../lib/sprite/sprite.rb')

namespace :sprite do  
  desc "build sprite images based on config/sprite.yml"
  task :build do
    Sprite.new.build
  end
  
  task :list => [:build] do
    # TODO
    # list all the currently configured sprites
  end
end
