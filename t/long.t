
BEGIN { $| = 1; print "1..25\n"; }
END {print "not ok 1\n" unless $loaded;}

use ShiftJIS::String qw(:all);

$^W = 1;
$loaded = 1;
print "ok 1\n";

#####

$n = 5000;
$f = 10;
$len = $f * $n;

$sub = "0123456Ç`Ç†àü";
$str = $sub x $n;
$rev = "àüÇ†Ç`6543210" x $n;

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

$try = "éééééééééé" x 10000;

print $try.'Å@' eq spaceH2Z($try.' ')
  ? "ok" : "not ok", " 16\n";
print $try.' '  eq spaceZ2H($try.'Å@')
  ? "ok" : "not ok", " 17\n";
print $try."AA" eq toupper($try."aA")
  ? "ok" : "not ok", " 18\n";
print $try."aa" eq tolower($try."aA")
  ? "ok" : "not ok", " 19\n";

print rspan($str, $sub) == 0 ? "ok" : "not ok", " 20\n";

print rspan($str, "A") == $len ? "ok" : "not ok", " 21\n";

print rcspan($str, "A") == 0 ? "ok" : "not ok", " 22\n";

print trim ($str, $sub) eq "" ? "ok" : "not ok", " 23\n";

print ltrim($str, $sub) eq "" ? "ok" : "not ok", " 24\n";

print rtrim($str, $sub) eq "" ? "ok" : "not ok", " 25\n";

__END__
