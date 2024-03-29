[![Ruby](https://github.com/djberg96/getopt/actions/workflows/ruby.yml/badge.svg)](https://github.com/djberg96/getopt/actions/workflows/ruby.yml)

## Description
The getopt Ruby library is a simple command line parsing library. It implements
a `Getopt::Std` class for basic command line parsing, as well as a `Getopt::Long`
class for more advanced command line parsing.

## Installation
`gem install getopt`

## Adding the trusted cert
`gem cert --add <(curl -Ls https://raw.githubusercontent.com/djberg96/getopt/main/certs/djberg96_pub.pem)`
   
## Synopsis
### Getopt::Std
```ruby
require 'getopt/std'

# Look for -o with argument, and -I and -D boolean arguments
opt = Getopt::Std.getopts("o:ID")

if opt["I"]
  # Do something if -I passed
  
if opt["D"]
  # Do something if -D passed
  
if opt["o"]
  case opt["o"]
    # blah, blah, blah
  end
end
```

### Getopt::Long
```ruby
require 'getopt/long'

opt = Getopt::Long.getopts(
  ["--foo", "-f", Getopt::BOOLEAN],
  ["--bar", "-b", Getopt::REQUIRED]
)
 
# Or, to save your fingers some typing:
#
# require "getopt/long"
# include Getopt
# opt = Long.getopts(
#    ["--foo", "-f", BOOLEAN],
#    ["--bar", "-b", REQUIRED]
# )

if opt["foo"]
  # Do something if --foo or -f passed
end

if opt["b"]
  # Do something if --bar or -b passed
end
```

## Singleton Methods
`Std.getopts(switches)`

Takes a series of single character switches that can be accepted on the
command line. Any characters followed by a ":" require an argument. The
rest are considered boolean switches.

The method returns a hash, with the switches as the key (minus the leading '-').
For boolean switches, the value is either true or false. Switches that were
not passed on the command line do not appear in the hash.

In the event that a switch which accepts an argument appears multiple times
the value for that key becomes an array of values.

`Long.getopts(switches)`

Takes an array of switches beginning with "--" followed by one or more
alphanumeric or hyphen characters, or "-" followed by a single character.
The type of argument, if any, can be specified as BOOLEAN, OPTIONAL,
REQUIRED or INCREMENT.

The array should be in the form:

```
# long form, short form (alias), option type
["--long", "-l", Getopt::OPTION]
```

Note that only the long form is required. If the short form is not
specified, it will automatically be set to the first letter of the long
switch. If multiple long switches with the same first character are
listed without short switches, only the first long switch gets the short
switch alias.

If the argument type is not specified, the default is BOOLEAN.

For the truly lazy, you can also pass a string of long switches (with
no short switches or argument types). 

See the 'examples' directory for more examples.

## Getopt::Long argument types
`REQUIRED`

If the option is specified on the command line, it must be followed by
a non-blank argument. This argument cannot be another switch. If this
switch appears multiple times, the values are collected into an array.

`BOOLEAN`

If the option is specified on the command line, its value is set to true.
It must not be followed by a non-blank argument, excluding other switches.
Attempting to pass a boolean switch more than once will raise an error.

`OPTIONAL`

If the option is specified on the command line, it may or may not accept
an argument, excluding other valid switches. If an argument is present,
it's value is set to that argument.  If an argument is not present, it's
value is set to nil.

`INCREMENT`

If the option is specified on the command line, its value is incremented
by one for each appearance on the command line, or set to 1 if it appears
only once.

## Future Plans

* Add support for negatable options so that you can do "--no-foo", for example.

* Add support for numeric types, so that you don't have to manually convert
  strings to numbers.

* Allow shortcut characters for the option types, e.g. "?" for BOOLEAN, "+"
  for INCREMENT, etc.

## Known Issues

### Getopt::Std
You cannot squish switches that require arguments with the argument itself.
For example, if you do `Getopt::Std.getopts("o:ID")`, it will not parse
"-IDohello" properly. Instead, you must do "-IDo hello". Or, you can just
separate the argument, e.g. "-I -D -o hello".

### Getopt::Long
If you mix and match compressed switches with separate, optional switches
the optional switch will be set to true instead of nil if it separated
from the compressed switches.
   
## Reporting Issues

If you find any other issues, please log them on the project
page at https://github.com/djberg96/getopt.

## Other Stuff
Neither class attempts to be POSIX compliant in any way, shape or form.

And I don't care!

## Notes From the Author
My main gripe with the `getoptlong` library currently in the standard library
is that it doesn't return a hash, yet gives you partial hash behavior. This
was both confusing and annoying, since the first thing I do (along with
everyone else) is collect the results into a hash for later processing.

My main gripe with the `optparse` library (also in the standard library) is
that it treats command line processing like event processing. It's too
complex, when most of the time all you want to do is slurp the command line
options into a hash.

So, I did something utterly novel with this library. I collected the command
line options ... (wait for it) ... into a hash! Then I give that hash to
you, aliases and all. I did get some ideas from Perl's Getopt::Long library,
but this is in no way a port of that module (which supports POSIX parsing, GNU
parsing, more option types, etc). My goal was to provide the functionality
that I felt would cover the vast majority of common cases, yet still provide
a little extra spice with switch types (REQUIRED, OPTIONAL, etc).

There are a few extra things I plan to add (see the 'Future Plans' above) but
I do not plan on this library ever becoming as feature rich as, say, Perl's
Getopt::Long module.
   
If you plan to write a full fledged command line application, e.g. you plan
on implementing a full help system, gobs of command line options and tons of
switches, consider Jim Freeze's `commandline` gem.

## Warranty
This package is provided "as is" and without any express or
implied warranties, including, without limitation, the implied
warranties of merchantability and fitness for a particular purpose.

## License
Apache-2.0

## Copyright
(C) 2005-2021, Daniel J. Berger
All Rights Reserved

## Author
Daniel J. Berger
