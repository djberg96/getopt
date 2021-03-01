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

  example "version" do
    expect(Getopt::Long::VERSION).to eq('1.6.0')
    expect(Getopt::Long::VERSION).to be_frozen
  end

  example "constants" do
    expect(Getopt::BOOLEAN).not_to be_nil
    expect(Getopt::OPTIONAL).not_to be_nil
    expect(Getopt::REQUIRED).not_to be_nil
    expect(Getopt::INCREMENT).not_to be_nil
  end

  example "getopts long basic functionality" do
    expect(Getopt::Long).to respond_to(:getopts)

    expect{ Getopt::Long.getopts(["--test"],["--help"],["--foo"]) }.not_to raise_error
    expect{ Getopt::Long.getopts(["--test", "-x"],["--help", "-y"],["--foo", "-z"]) }.not_to raise_error

    expect{
      Getopt::Long.getopts(
        ["--test", "-x", Getopt::BOOLEAN],
        ["--help", "-y", Getopt::REQUIRED],
        ["--foo",  "-z", Getopt::OPTIONAL],
        ["--more", "-m", Getopt::INCREMENT]
      )
    }.not_to raise_error

    expect(Getopt::Long.getopts("--test")).to be_kind_of(Hash)
  end

  example "getopts long using equals sign works as expected" do
    ARGV.push("--foo=hello","-b","world")

    expect{
      @opts = Getopt::Long.getopts(
        ["--foo", "-f", Getopt::REQUIRED],
        ["--bar", "-b", Getopt::OPTIONAL]
      )
    }.not_to raise_error

    expect(@opts["foo"]).to eq("hello")
    expect(@opts["f"]).to eq("hello")
    expect(@opts["bar"]).to eq("world")
    expect(@opts["b"]).to eq("world")
  end

  example "getopts long with embedded hyphens works as expected" do
    ARGV.push('--foo-bar', 'hello', '--test1-test2-test3', 'world')

    expect{
      @opts = Getopt::Long.getopts(
        ['--foo-bar', '-f', Getopt::REQUIRED],
        ['--test1-test2-test3', '-t', Getopt::REQUIRED]
      )
    }.not_to raise_error

    expect( @opts['foo-bar']).to eq('hello')
    expect( @opts['f']).to eq('hello')
    expect( @opts['test1-test2-test3']).to eq('world')
    expect( @opts['t']).to eq('world')
  end

=begin
  example "getopts_long_embedded_hyphens_using_equals_sign" do
    ARGV.push('--foo-bar=hello', '--test1-test2-test3=world')
    assert_nothing_raised{
      @opts = Long.getopts(
        ['--foo-bar', '-f', REQUIRED],
        ['--test1-test2-test3', '-t', REQUIRED]
      )
    }
    expect( @opts['foo-bar']).to eq('hello')
    expect( @opts['f']).to eq('hello')
    expect( @opts['test1-test2-test3']).to eq('world')
    expect( @opts['t']).to eq('world')
  end

  example "getopts_short_switch_squished" do
    ARGV.push("-f", "hello", "-bworld")
    assert_nothing_raised{
      @opts = Long.getopts(
        ["--foo", "-f", REQUIRED],
        ["--bar", "-b", OPTIONAL]
      )
    }
    expect( @opts["f"]).to eq("hello")
    expect( @opts["b"]).to eq("world")
  end

  example "getopts_increment_type" do
    ARGV.push("-m","-m")
    assert_nothing_raised{
      @opts = Long.getopts(["--more", "-m", INCREMENT])
    }
    expect( @opts["more"]).to eq(2)
    expect( @opts["m"]).to eq(2)
  end

  example "switches_exist" do
    ARGV.push("--verbose","--test","--foo")
    expect{ @opts = Long.getopts("--verbose --test --foo") }.not_to raise_error
    expect( @opts.has_key?("verbose")).to eq(true)
    expect( @opts.has_key?("test")).to eq(true)
    expect( @opts.has_key?("foo")).to eq(true)
  end

  example "short_switch_synonyms" do
    ARGV.push("--verbose","--test","--foo")
    expect{ @opts = Long.getopts("--verbose --test --foo") }.not_to raise_error
    expect( @opts.has_key?("v")).to eq(true)
    expect( @opts.has_key?("t")).to eq(true)
    expect( @opts.has_key?("f")).to eq(true)
  end

  example "short_switch_synonyms_with_explicit_types" do
    ARGV.push("--verbose", "--test", "hello", "--foo")
    assert_nothing_raised{
      @opts = Long.getopts(
        ["--verbose", BOOLEAN],
        ["--test", REQUIRED],
        ["--foo", BOOLEAN]
      )
    }
    assert(@opts.has_key?("v"))
    assert(@opts.has_key?("t"))
    assert(@opts.has_key?("f"))
  end

  example "switches_with_required_arguments" do
    ARGV.push("--foo","1","--bar","hello")
    assert_nothing_raised{
      @opts = Long.getopts(
        ["--foo", "-f", REQUIRED],
        ["--bar", "-b", REQUIRED]
      )
    }
    expect( @opts).to eq({"foo"=>"1", "bar"=>"hello", "f"=>"1", "b"=>"hello"})
  end

  example "compressed_switches" do
    ARGV.push("-fb")
    assert_nothing_raised{
      @opts = Long.getopts(
        ["--foo", "-f", BOOLEAN],
        ["--bar", "-b", BOOLEAN]
      )
    }
    expect( @opts).to eq({"foo"=>true, "f"=>true, "b"=>true, "bar"=>true})
  end

  example "compress_switches_with_required_arg" do
    ARGV.push("-xf", "foo.txt")
    assert_nothing_raised{
      @opts = Long.getopts(
        ["--expand", "-x", BOOLEAN],
        ["--file", "-f", REQUIRED]
      )
    }
    assert_equal(
      {"x"=>true, "expand"=>true, "f"=>"foo.txt", "file"=>"foo.txt"}, @opts
    )
  end

  example "compress_switches_with_compressed_required_arg" do
    ARGV.push("-xffoo.txt")
    assert_nothing_raised{
      @opts = Long.getopts(
        ["--expand", "-x", BOOLEAN],
        ["--file", "-f", REQUIRED]
      )
    }
    assert_equal(
     {"x"=>true, "expand"=>true, "f"=>"foo.txt", "file"=>"foo.txt"}, @opts
    )
  end

  example "compress_switches_with_optional_arg_not_defined" do
    ARGV.push("-xf")
    assert_nothing_raised{
      @opts = Long.getopts(
        ["--expand", "-x", BOOLEAN],
        ["--file", "-f", OPTIONAL]
      )
    }
    assert_equal(
      {"x"=>true, "expand"=>true, "f"=>nil, "file"=>nil}, @opts
    )
  end

  example "compress_switches_with_optional_arg" do
    ARGV.push("-xf", "boo.txt")
    assert_nothing_raised{
      @opts = Long.getopts(
        ["--expand", "-x", BOOLEAN],
        ["--file", "-f", OPTIONAL]
      )
    }
    assert_equal(
      {"x"=>true, "expand"=>true, "f"=>"boo.txt", "file"=>"boo.txt"}, @opts
    )
  end

  example "compress_switches_with_compressed_optional_arg" do
    ARGV.push("-xfboo.txt")
    assert_nothing_raised{
      @opts = Long.getopts(
        ["--expand", "-x", BOOLEAN],
        ["--file", "-f", OPTIONAL]
      )
    }
    assert_equal(
     {"x"=>true, "expand"=>true, "f"=>"boo.txt", "file"=>"boo.txt"}, @opts
    )
  end

  example "compressed_short_and_long_mixed" do
    ARGV.push("-xb", "--file", "boo.txt", "-v")
    assert_nothing_raised{
      @opts = Long.getopts(
        ["--expand", "-x", BOOLEAN],
        ["--verbose", "-v", BOOLEAN],
        ["--file", "-f", REQUIRED],
        ["--bar", "-b", OPTIONAL]
      )
      assert_equal(
        { "x"=>true, "expand"=>true,
          "v"=>true, "verbose"=>true,
          "f"=>"boo.txt", "file"=>"boo.txt",
          "b"=>nil, "bar"=>nil
        },
        @opts
      )
    }
  end

  example "multiple_similar_long_switches_with_no_short_switches" do
    ARGV.push('--to','1','--too','2','--tooo','3')
    assert_nothing_raised{
      @opts = Long.getopts(
        ["--to",  REQUIRED],
        ["--too", REQUIRED],
        ["--tooo", REQUIRED]
      )
    }
    expect( @opts['to']).to eq('1')
    expect( @opts['too']).to eq('2')
    expect( @opts['tooo']).to eq('3')
  end
=end

  after do
    @opts = nil
    ARGV.clear
  end
end
