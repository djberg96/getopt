require 'rake'
require 'rake/testtask'

task :clean do
  Dir['*.gem'].each{ |f| File.delete(f) }
  Dir['**/*.rbc'].each{ |f| File.delete(f) }
end

namespace :gem do
  desc "Create the getopt gem"
  task :create => [:clean] do
    spec = eval(IO.read('getopt.gemspec'))
    Gem::Builder.new(spec).build
  end

  desc "Install the getopt gem"
  task :install => [:create] do
    ruby 'getopt.gemspec'
    file = Dir["*.gem"].first
    sh "gem install #{file}"
  end
end

Rake::TestTask.new do |t|
  task :test => :clean
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

task :default => :test
