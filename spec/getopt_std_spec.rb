###################################################################
# test_getopt_std.rb
#
# Test suite for the Getopt::Std class. You should run this test
# via the 'rake test' task.
###################################################################
require 'rspec'
require 'getopt/std'
include Getopt

RSpec.describe Getopt::Std do
  example 'version' do
    expect(Std::VERSION).to eq('1.6.0')
    expect(Std::VERSION).to be_frozen
  end

  example 'getopts basic functionality' do
    expect(Std).to respond_to(:getopts)
    expect{ Std.getopts('ID') }.not_to raise_error
    expect(Std.getopts('ID')).to be_kind_of(Hash)
  end

  example 'getopts with separated switches' do
    ARGV.push('-I', '-D')
    expect(Std.getopts('ID')).to eq({'I' => true, 'D' => true})
  end

  # Inspired by RF bug #23477
  example 'getopts with arguments that match switch are ok' do
    ARGV.push('-d', 'd')
    expect(Std.getopts('d:')).to eq({'d' => 'd'})

    ARGV.push('-d', 'ad')
    expect(Std.getopts('d:')).to eq({'d' => 'ad'})

    ARGV.push('-a', 'ad')
    expect(Std.getopts('d:a:')).to eq({'a' => 'ad'})

    ARGV.push('-a', 'da')
    expect(Std.getopts('d:a:')).to eq({'a' => 'da'})

    ARGV.push('-a', 'd')
    expect(Std.getopts('d:a:')).to eq({'a' => 'd'})

    ARGV.push('-a', 'dad')
    expect(Std.getopts('d:a:')).to eq({'a' => 'dad'})

    ARGV.push('-d', 'd', '-a', 'a')
    expect(Std.getopts('d:a:')).to eq({'d' => 'd', 'a' => 'a'})
  end

  example 'getopts with joined switches' do
    ARGV.push('-ID')
    expect(Std.getopts('ID')).to eq({'I' => true, 'D' => true})
  end

  example 'getopts with separated switches and mandatory argument' do
    ARGV.push('-o', 'hello', '-I', '-D')
    expect(Std.getopts('o:ID')).to eq({'o' => 'hello', 'I' => true, 'D' => true})
  end

  example 'getopts with joined switches and mandatory argument' do
    ARGV.push('-IDo', 'hello')
    expect(Std.getopts('o:ID')).to eq({'o' => 'hello', 'I' => true, 'D' => true})
  end

  example 'getopts with no arguments' do
    expect{ Std.getopts('ID') }.not_to raise_error
    expect(Std.getopts('ID')).to eq({})
    expect(Std.getopts('ID')['I']).to be_nil
    expect(Std.getopts('ID')['D']).to be_nil
  end

  # If a switch that accepts an argument appears more than once, the values
  # are rolled into an array.
  example 'getopts with switch repeated' do
    ARGV.push('-I', '-I', '-o', 'hello', '-o', 'world')
    expect(Std.getopts('o:ID')).to eq({'o' => ['hello', 'world'], 'I' => true})
  end

  # EXPECTED ERRORS

  example 'getopts raises expected errors when passing a switch to another switch' do
    ARGV.push('-d', '-d')
    expect{ Std.getopts('d:a:') }.to raise_error(Getopt::Std::Error)

    ARGV.push('-d', '-a')
    expect{ Std.getopts('d:a:') }.to raise_error(Getopt::Std::Error)

    ARGV.push('-a', '-d')
    expect{ Std.getopts('d:a:') }.to raise_error(Getopt::Std::Error)

    ARGV.push('-d', '-d')
    expect{ Std.getopts('d:a:') }.to raise_error(Getopt::Std::Error, "cannot use switch '-d' as argument to another switch")
  end

  example 'getopts raises expected errors if argument is missing' do
    ARGV.push('-ID')
    expect{ Std.getopts('I:D') }.to raise_error(Std::Error)

    ARGV.push('-ID')
    expect{ Std.getopts('ID:') }.to raise_error(Std::Error)
  end

  example 'getopts raises expected errors if there are extra arguments' do
    ARGV.push('-I', '-D', '-X')
    expect{ Std.getopts('ID') }.to raise_error(Std::Error)

    ARGV.push('-IDX')
    expect{ Std.getopts('ID') }.to raise_error(Std::Error, "invalid option 'X'")
  end

  example 'getopts raises expected errors with invalid or no arguments' do
    expect{ Std.getopts }.to raise_error(ArgumentError)
    expect{ Std.getopts(0) }.to raise_error(NoMethodError)
    expect{ Std.getopts(nil) }.to raise_error(NoMethodError)
  end

  after do
    ARGV.clear
  end
end
