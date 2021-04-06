require 'rake'
require 'rake/clean'
require 'rspec/core/rake_task'

CLEAN.include("**/*.gem", "**/*.rbc", "**/*.lock")

namespace :gem do
  desc "Create the getopt gem"
  task :create => [:clean] do
    require 'rubygems/package'
    spec = eval(IO.read('getopt.gemspec'))
    spec.signing_key = File.join(Dir.home, '.ssh', 'gem-private_key.pem')
    Gem::Package.build(spec)
  end

  desc "Install the getopt gem"
  task :install => [:create] do
    file = Dir["*.gem"].first
    sh "gem install -l #{file}"
  end
end

namespace :spec do
  RSpec::Core::RakeTask.new(:all) do |t|
    t.pattern = FileList['spec/*_spec.rb']
  end

  RSpec::Core::RakeTask.new(:getopt_long) do |t|
    t.pattern = FileList['spec/*long_spec.rb']
  end

  RSpec::Core::RakeTask.new(:getopt_std) do |t|
    t.pattern = FileList['spec/*std_spec.rb']
  end
end

task :default => 'spec:all'
