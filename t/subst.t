# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..16\n"; }
END {print "not ok 1\n" unless $loaded;}
use ShiftJIS::String;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

print "ok 2\n";

# modified from a part of Perl 5.6.0 <t/op/subst.t> 
{
  $_ = "aaaaa";
  print ShiftJIS::String::strtr(\$_, 'a', 'b') == 5
    ? "ok 3\n" : "not ok 3\n";
  print ShiftJIS::String::strtr(\$_, 'a', 'b') == 0
    ? "ok 4\n" : "not ok 4\n";
  print ShiftJIS::String::strtr(\$_, 'b', '' ) == 5
    ? "ok 5\n" : "not ok 5\n";
  print ShiftJIS::String::strtr(\$_, 'b', 'c', 's') == 5
    ? "ok 6\n" : "not ok 6\n";
  print ShiftJIS::String::strtr(\$_, 'c', '' ) == 1
    ? "ok 7\n" : "not ok 7\n";
  print ShiftJIS::String::strtr(\$_, 'c', '', 'd') == 1
    ? "ok 8\n" : "not ok 8\n";
  print $_ eq "" ? "ok 9\n" : "not ok 9\n";

  my($x);
  $_ = "Now is the %#*! time for all good men...";
  print(($x = ShiftJIS::String::strtr(\$_, 'a-zA-Z ', '', 'cd')) == 7
	? "ok 10\n" : "not ok 10\n");
  print ShiftJIS::String::strtr(\$_, ' ', ' ', 's') == 8
    ? "ok 11\n" : "not ok 11\n";

  $_ = 'abcdefghijklmnopqrstuvwxyz0123456789';
  ShiftJIS::String::strtr(\$_, 'a-z', 'A-Z');
  print $_ eq 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789' ?
	"ok 12\n" : "not ok 12\n";

  # same as tr/A-Z/a-z/;
  ShiftJIS::String::strtr(\$_, "\101-\132", "\141-\172");

  print $_ eq 'abcdefghijklmnopqrstuvwxyz0123456789' ?
	"ok 13\n" : "not ok 13\n";

  if (ord("+") == ord(",") - 1 && ord(",") == ord("-") - 1 &&
    ord("a") == ord("b") - 1 && ord("b") == ord("c") - 1) {
    $_ = '+,-';
    ShiftJIS::String::strtr(\$_, '+--', 'a-c');
    print "not " unless  $_ eq 'abc';
  }
    print "ok 14\n";

  $_ = '+,-';
  ShiftJIS::String::strtr(\$_, '+\--', 'a/c');
  print $_ eq 'a,/' ? "ok 15\n" : "not ok 15\n";

  $_ = '+,-';
  ShiftJIS::String::strtr(\$_, '-+,', 'ab\-');
  print $_ eq 'b-a' ? "ok 16\n" : "not ok 16\n";
}

