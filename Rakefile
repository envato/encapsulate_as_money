require "bundler/gem_tasks"
require "rake/testtask"
require "yard"

task :default => :spec

Rake::TestTask.new(:spec) do |t|
  t.libs << "spec"
  t.test_files = Dir.glob("spec/**/*_spec.rb")
end

YARD::Rake::YardocTask.new
