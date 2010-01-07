require 'rubygems'

spec = Gem::Specification.new do |gem|
   gem.name       = 'getopt'
   gem.version    = '1.4.0'
   gem.author     = 'Daniel J. Berger'
   gem.license    = 'Artistic 2.0'
   gem.email      = 'djberg96@gmail.com'
   gem.homepage   = 'http://www.rubyforge.org/projects/shards'
   gem.platform   = Gem::Platform::RUBY
   gem.summary    = 'Getopt::Std and Getopt::Long option parsers for Ruby'
   gem.test_files = Dir['test/*.rb']
   gem.has_rdoc   = true
   gem.files      = Dir['**/*'].reject{ |f| f.include?('CVS') }

   gem.rubyforge_project = 'shards'
   gem.extra_rdoc_files  = ['README', 'CHANGES', 'MANIFEST']
   
   gem.add_development_dependency('test-unit', '>= 2.0.3')

   gem.description = <<-EOF
      The getopt library provides two different command line option parsers.
      They are meant as easier and more convenient replacements for the
      command line parsers that ship as part of the Ruby standard library.
      Please see the README for additional comments.
   EOF
end

Gem::Builder.new(spec).build
