namespace :sprite do  
  desc "build sprite images based on config/sprite.yml"
  task :build do
    require File.join(File.dirname(__FILE__), '../lib/sprite/sprite.rb')
    Sprite.new.build
  end
end
