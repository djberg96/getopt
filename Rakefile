require 'rake'
require 'rake/testtask'

desc "Install the getopt package (non-gem)"
task :install do
   dest = File.join(Config::CONFIG['sitelibdir'], 'getopt')
   Dir.mkdir(dest) unless File.exists? dest
   cp 'lib/getopt/std.rb', dest, :verbose => true
   cp 'lib/getopt/long.rb', dest, :verbose => true
end

desc "Install the getopt package as a gem"
task :install_gem do
   ruby 'getopt.gemspec'
   file = Dir["*.gem"].first
   sh "gem install #{file}"
end

Rake::TestTask.new do |t|
   t.warning = true
   t.verbose = true
end

Rake::TestTask.new('test_getopt_long') do |t|
   t.test_files = 'test/test_getopt_long.rb'
   t.warning = true
   t.verbose = true
end

Rake::TestTask.new('test_getopt_std') do |t|
   t.test_files = 'test/test_getopt_std.rb'
   t.warning = true
   t.verbose = true
end
