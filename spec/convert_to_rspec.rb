# convert test-unit files to rspec.
#
# This is not going to be perfect. Some hand editing will still be required,
# but a lot less than doing things manually.

file = ARGV.shift.chomp
ofile = File.basename(file, '.rb').sub(/^test_/, '') + '_spec.rb'

map = {
  /require 'test-unit'/ => "require 'rspec'",
  /class TC(.*)\< Test::Unit::TestCase/ => 'RSpec.describe \1do',
  /def setup/ => 'before do',
  /def teardown/ => 'after do',
  /def self.startup/ => '',
  /\s+@@(.*?)\s*\=\s*(.*?)\n/ => '  let(:\1) { \2 }',
  /test(.*)do/ => 'example\1do',
  /def test_(.*)/ => 'example "\1" do',
  /assert_kind_of\((.*),(.*)\)/m => 'expect(\2).to be_kind_of(\1)',
  /assert_respond_to\((.*),\s+(.*)\)/m => 'expect(\1).to respond_to(\2)',
  /assert_raise\((.*?)\){(.*?)}/m => 'expect{\2}.to raise_error(\1)',
  /assert_raises\((.*?)\){(.*?)}/m => 'expect{\2}.to raise_error(\1)',
  /assert_raise_kind_of\((.*?)\){(.*?)}/m => 'expect{\2}.to raise_error(\1)',
  /assert_nothing_raised{(.*?)}/m => 'expect{\1}.not_to raise_error',
  /assert_true\((.*)\)/m => 'expect(\1).to be true',
  /assert_false\((.*)\)/m => 'expect(\1).to be false',
  /assert_equal\((.*),(.*)\)/m => 'expect(\2).to eq(\1)',
  /assert_match\((.*),(.*)\)/m => 'expect(\2).to match(\1)',
  /assert_nil\((.*)\)/m => 'expect(\1).to be_nil',
  /assert_not_nil\((.*)\)/m => 'expect(\1).not_to be_nil',
  /assert_boolean\((.*)\)/m => 'expect(\1).to be(true).or be(false)',
  /omit_if\((.*)\)/m => 'skip if \1',
  /omit_unless\((.*)\)/m => 'skip unless \1',
}

begin
  fh = File.open(ofile, 'w')

  IO.foreach(file) do |line|
    match_found = false

    map.each do |original, replacement|
      if original.match(line)
        new_line = line.gsub(original, replacement)
        fh.puts new_line
        match_found = true
      end
    end

    fh.puts line unless match_found
  end
ensure
  fh.close
end
