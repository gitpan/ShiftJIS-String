# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..10\n"; }
END {print "not ok 1\n" unless $loaded;}
use ShiftJIS::String qw(strtr spaceH2Z spaceZ2H);

$^W = 1;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

print ShiftJIS::String::mkrange("") eq ""
  ? "ok 2\n" : "not ok 2\n";
print ShiftJIS::String::mkrange('-+\-XYZ-') eq "-+-XYZ-"
  ? "ok 3\n" : "not ok 3\n";
print ShiftJIS::String::mkrange("A-D") eq "ABCD"
  ? "ok 4\n" : "not ok 4\n";
print ShiftJIS::String::mkrange("‚Ÿ-‚¤") eq "‚Ÿ‚ ‚¡‚¢‚£‚¤"
  ? "ok 5\n" : "not ok 5\n";
print ShiftJIS::String::mkrange("0-9‚O-‚X") eq "0123456789‚O‚P‚Q‚R‚S‚T‚U‚V‚W‚X"
  ? "ok 6\n" : "not ok 6\n";
print ShiftJIS::String::mkrange("9-0") eq ""
  ? "ok 7\n" : "not ok 7\n";
print ShiftJIS::String::mkrange("0-9") eq "0123456789"
  ? "ok 8\n" : "not ok 8\n";
print ShiftJIS::String::mkrange("0-9",1) eq "0123456789"
  ? "ok 9\n" : "not ok 9\n";
print ShiftJIS::String::mkrange("9-0",1) eq "9876543210"
  ? "ok 10\n" : "not ok 10\n";
