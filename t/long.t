# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

BEGIN { $| = 1; print "1..19\n"; }
END {print "not ok 1\n" unless $loaded;}

use ShiftJIS::String qw(:all);

$^W = 1;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

my $n = 5000;
my $f = 10;
my $len = $f * $n;

my $sub = "0123456Ç`Ç†àü";
my $str = $sub x $n;
my $rev = "àüÇ†Ç`6543210" x $n;

print issjis($str) ? "ok" : "not ok", " 2\n";

print !issjis($str."\xFF") ? "ok" : "not ok", " 3\n";

print length($str) == $len ? "ok" : "not ok", " 4\n";

print tolower($str) eq $str ? "ok" : "not ok", " 5\n";

print toupper($str."perl") eq $str."PERL" ? "ok" : "not ok", " 6\n";

print index($str, "perl") == -1 ? "ok" : "not ok", " 7\n";

print index($str.'ÇoÇÖÇíÇå', 'ÇÖÇíÇå') == $len + 1 ? "ok" : "not ok", " 8\n";

print rindex($str, "Ç†àü") == $len - 2 ? "ok" : "not ok", " 9\n";

print rindex($str, "perl") == -1 ? "ok" : "not ok", " 10\n";

print strspn($str, $sub) == $len ? "ok" : "not ok", " 11\n";

print strcspn($str, "A") == $len ? "ok" : "not ok", " 12\n";

print strrev($str) eq $rev ? "ok" : "not ok", " 13\n";

print substr($str,-1) eq 'àü' ? "ok" : "not ok", " 14\n";

print substr($str,1000*$f,2000*$f) eq ($sub x 2000)
  ? "ok" : "not ok", " 15\n";

my $try = "éééééééééé" x 10000;

print $try.'Å@' eq spaceH2Z($try.' ')
  ? "ok" : "not ok", " 16\n";
print $try.' '  eq spaceZ2H($try.'Å@')
  ? "ok" : "not ok", " 17\n";
print $try."AA" eq toupper($try."aA")
  ? "ok" : "not ok", " 18\n";
print $try."aa" eq tolower($try."aA")
  ? "ok" : "not ok", " 19\n";
