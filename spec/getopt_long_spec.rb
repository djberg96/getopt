#####################################################################
# getopt_long_spec.rb
#
# Specs for the getopt-long library. You should run this test
# via the 'rake spec:getopt_long' rake task.
#####################################################################
require 'rspec'
require 'getopt/long'

RSpec.describe Getopt::Long do
  before do
    @opts = nil
  end

  after do
    @opts = nil
    ARGV.clear
  end
  example 'version' do
    expect(Getopt::Long::VERSION).to eq('1.6.0')
    expect(Getopt::Long::VERSION).to be_frozen
  end

  example 'constants' do
    expect(Getopt::BOOLEAN).not_to be_nil
    expect(Getopt::OPTIONAL).not_to be_nil
    expect(Getopt::REQUIRED).not_to be_nil
    expect(Getopt::INCREMENT).not_to be_nil
  end

  example 'getopts long basic functionality' do
    expect(described_class).to respond_to(:getopts)

    expect{ described_class.getopts(['--test'], ['--help'], ['--foo']) }.not_to raise_error
    expect{ described_class.getopts(['--test', '-x'], ['--help', '-y'], ['--foo', '-z']) }.not_to raise_error

    expect{
      described_class.getopts(
        ['--test', '-x', Getopt::BOOLEAN],
        ['--help', '-y', Getopt::REQUIRED],
        ['--foo',  '-z', Getopt::OPTIONAL],
        ['--more', '-m', Getopt::INCREMENT]
      )
    }.not_to raise_error

    expect(described_class.getopts('--test')).to be_kind_of(Hash)
  end

  example 'getopts long using equals sign works as expected' do
    ARGV.push('--foo=hello', '-b', 'world')

    expect{
      @opts = described_class.getopts(
        ['--foo', '-f', Getopt::REQUIRED],
        ['--bar', '-b', Getopt::OPTIONAL]
      )
    }.not_to raise_error

    expect(@opts['foo']).to eq('hello')
    expect(@opts['f']).to eq('hello')
    expect(@opts['bar']).to eq('world')
    expect(@opts['b']).to eq('world')
  end

  example 'getopts long with embedded hyphens works as expected' do
    ARGV.push('--foo-bar', 'hello', '--test1-test2-test3', 'world')

    expect{
      @opts = described_class.getopts(
        ['--foo-bar', '-f', Getopt::REQUIRED],
        ['--test1-test2-test3', '-t', Getopt::REQUIRED]
      )
    }.not_to raise_error

    expect(@opts['foo-bar']).to eq('hello')
    expect(@opts['f']).to eq('hello')
    expect(@opts['test1-test2-test3']).to eq('world')
    expect(@opts['t']).to eq('world')
  end

  example 'getopts long embedded hyphens using equals sign works as expected' do
    ARGV.push('--foo-bar=hello', '--test1-test2-test3=world')

    expect{
      @opts = described_class.getopts(
        ['--foo-bar', '-f', Getopt::REQUIRED],
        ['--test1-test2-test3', '-t', Getopt::REQUIRED]
      )
    }.not_to raise_error

    expect(@opts['foo-bar']).to eq('hello')
    expect(@opts['f']).to eq('hello')
    expect(@opts['test1-test2-test3']).to eq('world')
    expect(@opts['t']).to eq('world')
  end

  example 'getopts long with short switch squished works as expected' do
    ARGV.push('-f', 'hello', '-bworld')

    expect{
      @opts = described_class.getopts(
        ['--foo', '-f', Getopt::REQUIRED],
        ['--bar', '-b', Getopt::OPTIONAL]
      )
    }.not_to raise_error

    expect(@opts['f']).to eq('hello')
    expect(@opts['b']).to eq('world')
  end

  example 'getopts long increment type works as expected' do
    ARGV.push('-m', '-m')

    expect{ @opts = described_class.getopts(['--more', '-m', Getopt::INCREMENT]) }.not_to raise_error

    expect(@opts['more']).to eq(2)
    expect(@opts['m']).to eq(2)
  end

  example 'switches are set as expected' do
    ARGV.push('--verbose', '--test', '--foo')
    expect{ @opts = described_class.getopts('--verbose --test --foo') }.not_to raise_error
    expect(@opts.key?('verbose')).to be(true)
    expect(@opts.key?('test')).to be(true)
    expect(@opts.key?('foo')).to be(true)
  end

  example 'short switch synonyms work as expected' do
    ARGV.push('--verbose', '--test', '--foo')
    expect{ @opts = described_class.getopts('--verbose --test --foo') }.not_to raise_error
    expect(@opts.key?('v')).to be(true)
    expect(@opts.key?('t')).to be(true)
    expect(@opts.key?('f')).to be(true)
  end

  example 'short_switch_synonyms_with_explicit_types' do
    ARGV.push('--verbose', '--test', 'hello', '--foo')

    expect{
      @opts = described_class.getopts(
        ['--verbose', Getopt::BOOLEAN],
        ['--test', Getopt::REQUIRED],
        ['--foo', Getopt::BOOLEAN]
      )
    }.not_to raise_error

    expect(@opts.key?('v')).to be(true)
    expect(@opts.key?('t')).to be(true)
    expect(@opts.key?('f')).to be(true)
  end

  example 'switches with required arguments when present' do
    ARGV.push('--foo', '1', '--bar', 'hello')

    expect{
      @opts = described_class.getopts(
        ['--foo', '-f', Getopt::REQUIRED],
        ['--bar', '-b', Getopt::REQUIRED]
      )
    }.not_to raise_error

    expect(@opts).to eq({'foo' => '1', 'bar' => 'hello', 'f' => '1', 'b' => 'hello'})
  end

  example "error is raised if argument isn't provided for switch that requires it" do
    ARGV.push('-f', '1', '-b')

    expect{
      @opts = described_class.getopts(
        ['--foo', '-f', Getopt::REQUIRED],
        ['--bar', '-b', Getopt::REQUIRED]
      )
    }.to raise_error(Getopt::Long::Error)
  end

  example 'compressed switches work as expected' do
    ARGV.push('-fb')

    expect{
      @opts = described_class.getopts(
        ['--foo', '-f', Getopt::BOOLEAN],
        ['--bar', '-b', Getopt::BOOLEAN]
      )
    }.not_to raise_error

    expect(@opts).to eq({'foo' => true, 'f' => true, 'b' => true, 'bar' => true})
  end

  example 'compress switches with required argument works as expected' do
    ARGV.push('-xf', 'foo.txt')

    expect{
      @opts = described_class.getopts(
        ['--expand', '-x', Getopt::BOOLEAN],
        ['--file', '-f', Getopt::REQUIRED]
      )
    }.not_to raise_error

    expect(@opts).to eq({'x' => true, 'expand' => true, 'f' => 'foo.txt', 'file' => 'foo.txt'})
  end

  example 'compress switches with argument that is compressed works as expected' do
    ARGV.push('-xffoo.txt')

    expect{
      @opts = described_class.getopts(
        ['--expand', '-x', Getopt::BOOLEAN],
        ['--file', '-f', Getopt::REQUIRED]
      )
    }.not_to raise_error

    expect(@opts).to eq({'x' => true, 'expand' => true, 'f' => 'foo.txt', 'file' => 'foo.txt'})
  end

  example 'compress switches with optional argument not defined works as expected' do
    ARGV.push('-xf')

    expect{
      @opts = described_class.getopts(
        ['--expand', '-x', Getopt::BOOLEAN],
        ['--file', '-f', Getopt::OPTIONAL]
      )
    }.not_to raise_error

    expect(@opts).to eq({'x' => true, 'expand' => true, 'f' => nil, 'file' => nil})
  end

  example 'compress switches with optional argument works as expected' do
    ARGV.push('-xf', 'boo.txt')

    expect{
      @opts = described_class.getopts(
        ['--expand', '-x', Getopt::BOOLEAN],
        ['--file', '-f', Getopt::OPTIONAL]
      )
    }.not_to raise_error

    expect(@opts).to eq({'x' => true, 'expand' => true, 'f' => 'boo.txt', 'file' => 'boo.txt'})
  end

  example 'compress switches with compressed optional argument works as expected' do
    ARGV.push('-xfboo.txt')

    expect{
      @opts = described_class.getopts(
        ['--expand', '-x', Getopt::BOOLEAN],
        ['--file', '-f', Getopt::OPTIONAL]
      )
    }.not_to raise_error

    expect(@opts).to eq({'x' => true, 'expand' => true, 'f' => 'boo.txt', 'file' => 'boo.txt'})
  end

  example 'compressed_short_and_long_mixed' do
    ARGV.push('-xb', '--file', 'boo.txt', '-v')

    expect{
      @opts = described_class.getopts(
        ['--expand', '-x', Getopt::BOOLEAN],
        ['--verbose', '-v', Getopt::BOOLEAN],
        ['--file', '-f', Getopt::REQUIRED],
        ['--bar', '-b', Getopt::OPTIONAL]
      )
    }.not_to raise_error

    expect(@opts).to eq({
      'x' => true, 'expand' => true,
      'v' => true, 'verbose' => true,
      'f' => 'boo.txt', 'file' => 'boo.txt',
      'b' => nil, 'bar' => nil
    })
  end

  example 'multiple similar long switches with no short switches works as expected' do
    ARGV.push('--to', '1', '--too', '2', '--tooo', '3')

    expect{
      @opts = described_class.getopts(
        ['--to',  Getopt::REQUIRED],
        ['--too', Getopt::REQUIRED],
        ['--tooo', Getopt::REQUIRED]
      )
    }.not_to raise_error

    expect(@opts['to']).to eq('1')
    expect(@opts['too']).to eq('2')
    expect(@opts['tooo']).to eq('3')
  end
end
