# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..8\n"; }
END {print "not ok 1\n" unless $loaded;}
use ShiftJIS::String qw(strtr spaceH2Z spaceZ2H);
$^W = 1;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

print 0 == ShiftJIS::String::length("")
  ? "ok 2\n" : "not ok 2\n";

print 3 == ShiftJIS::String::length("abc")
  ? "ok 3\n" : "not ok 3\n";

print 5 == ShiftJIS::String::length("±²³´µ")
  ? "ok 4\n" : "not ok 4\n";

print 10 == ShiftJIS::String::length("‚ ‚©‚³‚½‚È‚Í‚Ü‚â‚ç‚í")
  ? "ok 5\n" : "not ok 5\n";

print 9 == ShiftJIS::String::length('AIUEO“ú–{Š¿Žš')
  ? "ok 6\n" : "not ok 6\n";

print 5 == ShiftJIS::String::length("+15.3")
  ? "ok 7\n" : "not ok 7\n";

print 1 == ShiftJIS::String::length('Q')
  ? "ok 8\n" : "not ok 8\n";
