require 'rake/testtask'
require 'yard'

# Documentation with yard.
YARD::Rake::YardocTask.new do |t|
 t.files   = ['lib/**/*.rb']
 t.stats_options = ['--list-undoc']
end

# Tests with minitest.
Rake::TestTask.new do |t|
  t.libs = ['lib']
  t.test_files = FileList['test/*.rb']
end
