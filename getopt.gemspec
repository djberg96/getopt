require 'rubygems'

Gem::Specification.new do |spec|
  spec.name       = 'getopt'
  spec.version    = '1.5.1'
  spec.author     = 'Daniel J. Berger'
  spec.license    = 'Apache-2.0'
  spec.email      = 'djberg96@gmail.com'
  spec.homepage   = 'https://github.com/djberg96/getopt'
  spec.summary    = 'Getopt::Std and Getopt::Long option parsers for Ruby'
  spec.test_files = Dir['test/*.rb']
  spec.files      = Dir['**/*'].reject{ |f| f.include?('git') }
  spec.cert_chain = Dir['certs/*']

  spec.extra_rdoc_files  = ['README.rdoc', 'CHANGES.rdoc', 'MANIFEST.rdoc']
   
  spec.add_development_dependency('test-unit', '>= 2.5.0')
  spec.required_ruby_version = '>= 2.2.0'

  spec.metadata = {
    'homepage_uri'      => 'https://github.com/djberg96/getopt',
    'bug_tracker_uri'   => 'https://github.com/djberg96/getopt/issues',
    'changelog_uri'     => 'https://github.com/djberg96/getopt/blob/master/CHANGES',
    'documentation_uri' => 'https://github.com/djberg96/getopt/wiki',
    'source_code_uri'   => 'https://github.com/djberg96/getopt',
    'wiki_uri'          => 'https://github.com/djberg96/getopt/wiki'
  }

  spec.description = <<-EOF
    The getopt library provides two different command line option parsers.
    They are meant as easier and more convenient replacements for the
    command line parsers that ship as part of the Ruby standard library.
    Please see the README for additional comments.
  EOF
end
