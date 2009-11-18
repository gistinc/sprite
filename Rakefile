require 'rake'
require 'spec/rake/spectask'
require 'jeweler'

desc 'Default: run unit tests.'
task :default => :spec

desc "Run all specs in spec directory"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
end

Jeweler::Tasks.new do |gemspec|
  gemspec.name = "sprite"
  gemspec.summary = "generate your css sprites automagically"
  gemspec.description = "sprite is a rails/merb plugin that generates sprites for css, sass"
  gemspec.email = "merbjedi@gmail.com"
  gemspec.homepage = "http://github.com/merbjedi/sprite" 
  gemspec.authors = ["Jacques Crocker", "Richard Huang"]
  gemspec.files.exclude '.gitignore'
  
  # removing test files and specs from the gem to save space
  gemspec.files -= Dir.glob("spec/**/*")
  gemspec.test_files = []
end
Jeweler::GemcutterTasks.new

