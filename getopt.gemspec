require 'rubygems'

Gem::Specification.new do |spec|
  spec.name       = 'getopt'
  spec.version    = '1.6.0'
  spec.author     = 'Daniel J. Berger'
  spec.license    = 'Apache-2.0'
  spec.email      = 'djberg96@gmail.com'
  spec.homepage   = 'https://github.com/djberg96/getopt'
  spec.summary    = 'Getopt::Std and Getopt::Long option parsers for Ruby'
  spec.test_files = Dir['spec/*_spec.rb']
  spec.files      = Dir['**/*'].reject{ |f| f.include?('git') }
  spec.cert_chain = Dir['certs/*']

  spec.add_development_dependency('rake')
  spec.add_development_dependency('rspec', '~> 3.9')

  spec.metadata = {
    'homepage_uri'      => 'https://github.com/djberg96/getopt',
    'bug_tracker_uri'   => 'https://github.com/djberg96/getopt/issues',
    'changelog_uri'     => 'https://github.com/djberg96/getopt/blob/main/CHANGES',
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
