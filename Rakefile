require 'rake'
require 'rake/clean'
require 'rake/testtask'

CLEAN.include("**/*.gem", "**/*.rbc")

namespace :gem do
  desc "Create the getopt gem"
  task :create => [:clean] do
    require 'rubygems/package'
    spec = eval(IO.read('getopt.gemspec'))
    spec.signing_key = File.join(Dir.home, '.ssh', 'gem-private_key.pem')
    Gem::Package.build(spec, true)
  end

  desc "Install the getopt gem"
  task :install => [:create] do
    file = Dir["*.gem"].first
    sh "gem install -l #{file}"
  end
end

Rake::TestTask.new do |t|
  t.warning = true
  t.verbose = true
end

namespace :test do
  Rake::TestTask.new('getopt_long') do |t|
    t.test_files = 'test/test_getopt_long.rb'
    t.warning = true
    t.verbose = true
  end

  Rake::TestTask.new('getopt_std') do |t|
    t.test_files = 'test/test_getopt_std.rb'
    t.warning = true
    t.verbose = true
  end
end

task :default => :test
