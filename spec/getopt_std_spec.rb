# frozen_string_literal: true

###################################################################
# test_getopt_std.rb
#
# Test suite for the Getopt::described_class class. You should run this test
# via the 'rake test' task.
###################################################################
require 'rspec'
require 'getopt/std'

RSpec.describe Getopt::Std do
  after do
    ARGV.clear
  end

  example 'version' do
    expect(described_class::VERSION).to eq('1.6.0')
    expect(described_class::VERSION).to be_frozen
  end

  example 'getopts basic functionality' do
    expect(described_class).to respond_to(:getopts)
    expect{ described_class.getopts('ID') }.not_to raise_error
    expect(described_class.getopts('ID')).to be_a(Hash)
  end

  example 'getopts with separated switches' do
    ARGV.push('-I', '-D')
    expect(described_class.getopts('ID')).to eq({'I' => true, 'D' => true})
  end

  # Inspired by RF bug #23477
  example 'getopts with arguments that match switch are ok' do
    ARGV.push('-d', 'd')
    expect(described_class.getopts('d:')).to eq({'d' => 'd'})

    ARGV.push('-d', 'ad')
    expect(described_class.getopts('d:')).to eq({'d' => 'ad'})

    ARGV.push('-a', 'ad')
    expect(described_class.getopts('d:a:')).to eq({'a' => 'ad'})

    ARGV.push('-a', 'da')
    expect(described_class.getopts('d:a:')).to eq({'a' => 'da'})

    ARGV.push('-a', 'd')
    expect(described_class.getopts('d:a:')).to eq({'a' => 'd'})

    ARGV.push('-a', 'dad')
    expect(described_class.getopts('d:a:')).to eq({'a' => 'dad'})

    ARGV.push('-d', 'd', '-a', 'a')
    expect(described_class.getopts('d:a:')).to eq({'d' => 'd', 'a' => 'a'})
  end

  example 'getopts with joined switches' do
    ARGV.push('-ID')
    expect(described_class.getopts('ID')).to eq({'I' => true, 'D' => true})
  end

  example 'getopts with separated switches and mandatory argument' do
    ARGV.push('-o', 'hello', '-I', '-D')
    expect(described_class.getopts('o:ID')).to eq({'o' => 'hello', 'I' => true, 'D' => true})
  end

  example 'getopts with joined switches and mandatory argument' do
    ARGV.push('-IDo', 'hello')
    expect(described_class.getopts('o:ID')).to eq({'o' => 'hello', 'I' => true, 'D' => true})
  end

  example 'getopts with no arguments' do
    expect{ described_class.getopts('ID') }.not_to raise_error
    expect(described_class.getopts('ID')).to eq({})
    expect(described_class.getopts('ID')['I']).to be_nil
    expect(described_class.getopts('ID')['D']).to be_nil
  end

  # If a switch that accepts an argument appears more than once, the values
  # are rolled into an array.
  example 'getopts with switch repeated' do
    ARGV.push('-I', '-I', '-o', 'hello', '-o', 'world')
    expect(described_class.getopts('o:ID')).to eq({'o' => ['hello', 'world'], 'I' => true})
  end

  # EXPECTED ERRORS

  example 'getopts raises expected errors when passing a switch to another switch' do
    msg = "cannot use switch '-d' as argument to another switch"

    ARGV.push('-d', '-d')
    expect{ described_class.getopts('d:a:') }.to raise_error(Getopt::Std::Error)

    ARGV.push('-d', '-a')
    expect{ described_class.getopts('d:a:') }.to raise_error(Getopt::Std::Error)

    ARGV.push('-a', '-d')
    expect{ described_class.getopts('d:a:') }.to raise_error(Getopt::Std::Error)

    ARGV.push('-d', '-d')
    expect{ described_class.getopts('d:a:') }.to raise_error(Getopt::Std::Error, msg)
  end

  example 'getopts raises expected errors if argument is missing' do
    ARGV.push('-ID')
    expect{ described_class.getopts('I:D') }.to raise_error(Getopt::Std::Error)

    ARGV.push('-ID')
    expect{ described_class.getopts('ID:') }.to raise_error(Getopt::Std::Error)
  end

  example 'getopts raises expected errors if there are extra arguments' do
    ARGV.push('-I', '-D', '-X')
    expect{ described_class.getopts('ID') }.to raise_error(Getopt::Std::Error)

    ARGV.push('-IDX')
    expect{ described_class.getopts('ID') }.to raise_error(Getopt::Std::Error, "invalid option 'X'")
  end

  example 'getopts raises expected errors with invalid or no arguments' do
    expect{ described_class.getopts }.to raise_error(ArgumentError)
    expect{ described_class.getopts(0) }.to raise_error(NoMethodError)
    expect{ described_class.getopts(nil) }.to raise_error(NoMethodError)
  end
end
