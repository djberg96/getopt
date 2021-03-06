## 1.5.1 - 23-Mar-2020
* Properly add a LICENSE file since the Apache-2.0 license requires it.
* Added explicit .rdoc extensions to the README, CHANGES and MANIFEST files,
  mostly so they look nicer on github.

## 1.5.0 - 25-Jan-2019
* Changed license to Apache-2.0.

## 1.4.4 - 24-Mar-2018
* Fixed a deprecation warning.
* Now requires Ruby 2.2 or later.
* Added metadata to the gemspec.
* Updated the cert.

## 1.4.3 - 7-Jan-2016
* This gem is now signed.
* The gem related tasks in the Rakefile now assume Rubygems 2.x.
* Added getopt.rb, getopt-std.rb and getopt-long.rb files for convenience.

## 1.4.2 - 12-Oct-2014
* Updated Rakefile, README and gemspec.
* Minor updates to the test file and examples.

## 1.4.1 - 17-Jul-2011
* Now works with Ruby 1.9.x. Thanks go to Shura for the patch.
* Refactored the gemspec. Gem building code is now handled by Rake tasks.
* Refactored the Rakefile. Added a default task, removed the old install
  task, and namespaced the gem related tasks.

## 1.4.0 - 5-Sep-2009
* Fixed a packaging bug where the libs weren't actually being included! Gah!
  Thanks go to Steven Hilton for the spot.
* Other minor refactorings to the gemspec.
* The release number does not reflect any code changes. I simply ran out
  of numbers. :)

## 1.3.9 - 29-Jul-2009
* Now compatible with Ruby 1.9.x.
* Gemspec updates, including a license change to Artistic 2.0.
* Added individual rake tasks for testing Getopt::Long and Getopt::Std.
* Changed the 'release - date' format of this file.
* The test-unit library was switched from a standard dependency to a
  development dependency.

## 1.3.8 - 6-Jan-2008
* Fixed RF bug #23477 - Getopt::Std inadvertently raises an error if you
  pass a letter (without a hyphen) as an argument to a switch that matches
  that letter, e.g. "-a a" should be legal. Thanks go to an anonymous user
  for the spot.
* Added tests for RF bug #23477.
* Added Test::Unit 2.x as a prerequisite.

## 1.3.7 - 27-Jul-2008
* Fixed a potential infinite hash recursion bug in ARGV processing. This
  was smoked out as the result of the alternate hash implementations in
  JRuby and Ruby 1.9.
* Added the example programs to the gemspec.
* Removed the ts_all.rb file, and renamed the other test files. The Rakefile
  test task was updated accordingly.

## 1.3.6 - 8-Aug-2007
* The Getopt::StdError class is now Getopt::Std::Error.
* The Getopt::LongError class is now Getopt::Long::Error.
* Added some inline rdoc documentation to the source code.
* Added a Rakefile with tasks for installation and testing.
* Removed the install.rb file - use the 'rake install' task instead.

## 1.3.5 - 5-Jul-2006
* Fixed a bug where multiple long switches with the same first character
  could cause invalid results.  Thanks go to Michael Campbell for the spot.
* Added documentation to the README file that explains what happens if you
  specify multiple long switches with the same first character and no short
  switch alias.

## 1.3.4 - 7-Mar-2006
* Fixed Getopt::Long so that it can handle embedded hyphens in the long
  form, e.g. --foo-bar.  Thanks go to Mark Meves for the spot.
* Corresponding test suite additions.
* Added example to the 'example_long.rb' file that uses long form with
  embedded hyphens.

## 1.3.3 - 22-Feb-2006
* Bug fix for the two argument form of Getopt::Long.getopts.
* Corresponding test suite additions.

## 1.3.2 - 13-Feb-2006
* Improved error message if an option is passed without a preceding switch.
* Minor documentation fixes and clarifications.

## 1.3.1 - 18-Nov-2005
* Added support for compressed switches with getopt/long.
* More tests.
* Fixed a bug in the gemspec.

## 1.3.0 - 4-Nov-2005
* Added the Getopt::Long class (long.rb). This is a complete revamp of the
  old getoptlong package, with ideas tossed in from Perl's Getopt::Long
  package. See the README and example script for more detail.
* Added an example, and renamed the "test_std.rb" example to "example_std.rb".
* Added lots of documentation to the README file.
* Updated the MANIFEST, test suite, etc.

## 1.2.0 - 24-Oct-2005
* Altered the way multiple occurrences of the same switch are handled, for
  those switches that accept arguments.

## 1.1.0 - 7-Oct-2005
* Changed parser, added a bit stricter enforcement
* Now handles squished arguments properly, e.g. "-ID" as well as "-I -D"
* Some test suite changes

## 1.0.0 - 5-Oct-2005
* Initial commit
