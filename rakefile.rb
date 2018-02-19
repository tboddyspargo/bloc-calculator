require 'rake/testtask'
require 'yard'

# Documentation with yard.
YARD::Rake::YardocTask.new do |t|
 t.files   = ['lib/**/*.rb']
 # t.options = ['--any', '--extra', '--opts']
 t.stats_options = ['--list-undoc']
end

# Tests with minitest.
Rake::TestTask.new do |t|
  t.libs << 'test'
end
