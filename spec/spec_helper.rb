require 'rubygems'
require 'spec/autorun'
require 'date'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "/../lib"))

require 'sprite'

# set Sprite.root to be this spec/ folder
Sprite.module_eval{ @root = File.dirname(__FILE__) }