require 'rake'
require 'sprite/sprite'
unless Rake::Task.task_defined? "sprite:build"
  load File.join(File.dirname(__FILE__), '..', 'tasks', 'sprite_tasks.rake')
end

