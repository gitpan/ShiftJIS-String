
BEGIN { $| = 1; print "1..80\n"; }
END {print "not ok 1\n" unless $loaded;}

use ShiftJIS::String qw(:all);

$^W = 1;
$loaded = 1;
print "ok 1\n";

#####

$n = 5000;
$f = 10;
$len = $f * $n;

$sub = "0123456�`����";
$str = $sub x $n;
$rev = "�����`6543210" x $n;

print issjis($str) ? "ok" : "not ok", " 2\n";

print !issjis($str."\xFF") ? "ok" : "not ok", " 3\n";

print length($str) == $len ? "ok" : "not ok", " 4\n";

print tolower($str) eq $str ? "ok" : "not ok", " 5\n";

print toupper($str."perl") eq $str."PERL" ? "ok" : "not ok", " 6\n";

print index($str, "perl") == -1 ? "ok" : "not ok", " 7\n";

print index($str.'�o������', '������') == $len + 1 ? "ok" : "not ok", " 8\n";

print rindex($str, "����") == $len - 2 ? "ok" : "not ok", " 9\n";

print rindex($str, "perl") == -1 ? "ok" : "not ok", " 10\n";

print strspn($str, $sub) == $len ? "ok" : "not ok", " 11\n";

print strcspn($str, "A") == $len ? "ok" : "not ok", " 12\n";

print strrev($str) eq $rev ? "ok" : "not ok", " 13\n";

print substr($str,-1) eq '��' ? "ok" : "not ok", " 14\n";

print substr($str,1000*$f,2000*$f) eq ($sub x 2000)
  ? "ok" : "not ok", " 15\n";

$try = "����������" x 10000;

print $try.'�@' eq spaceH2Z($try.' ')
  ? "ok" : "not ok", " 16\n";
print $try.' '  eq spaceZ2H($try.'�@')
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

$vu = '���J';
print kataH2Z('�'x$n)  eq '�A'x$n ? "ok" : "not ok", " 26\n";
print kataH2Z('��'x$n) eq '�K'x$n ? "ok" : "not ok", " 27\n";
print kataH2Z('��'x$n) eq '�p'x$n ? "ok" : "not ok", " 28\n";
print kataH2Z('�'x$n)  eq '�E'x$n ? "ok" : "not ok", " 29\n";
print kanaH2Z('��'x$n) eq '��'x$n ? "ok" : "not ok", " 30\n";

print kanaH2Z('�'x$n)  eq '�A'x$n ? "ok" : "not ok", " 31\n";
print kanaH2Z('��'x$n) eq '�K'x$n ? "ok" : "not ok", " 32\n";
print kanaH2Z('��'x$n) eq '�p'x$n ? "ok" : "not ok", " 33\n";
print kanaH2Z('�'x$n)  eq '�E'x$n ? "ok" : "not ok", " 34\n";
print kanaH2Z('��'x$n) eq '��'x$n ? "ok" : "not ok", " 35\n";

print hiraH2Z('�'x$n)  eq '��'x$n ? "ok" : "not ok", " 36\n";
print hiraH2Z('��'x$n) eq '��'x$n ? "ok" : "not ok", " 37\n";
print hiraH2Z('��'x$n) eq '��'x$n ? "ok" : "not ok", " 38\n";
print hiraH2Z('�'x$n)  eq '�E'x$n ? "ok" : "not ok", " 39\n";
print hiraH2Z('��'x$n) eq $vu x$n ? "ok" : "not ok", " 40\n";

print kataZ2H('�A'x$n) eq '�' x$n ? "ok" : "not ok", " 41\n";
print kataZ2H('�K'x$n) eq '��'x$n ? "ok" : "not ok", " 42\n";
print kataZ2H('�p'x$n) eq '��'x$n ? "ok" : "not ok", " 43\n";
print kataZ2H('�E'x$n) eq '�' x$n ? "ok" : "not ok", " 44\n";
print kanaZ2H('��'x$n) eq '��'x$n ? "ok" : "not ok", " 45\n";

print hiraZ2H('��'x$n) eq '�' x$n ? "ok" : "not ok", " 46\n";
print hiraZ2H('��'x$n) eq '��'x$n ? "ok" : "not ok", " 47\n";
print hiraZ2H('��'x$n) eq '��'x$n ? "ok" : "not ok", " 48\n";
print hiraZ2H('�E'x$n) eq '�' x$n ? "ok" : "not ok", " 49\n";
print hiraZ2H($vu x$n) eq '��'x$n ? "ok" : "not ok", " 50\n";

print kanaZ2H('�A'x$n) eq '�' x$n ? "ok" : "not ok", " 51\n";
print kanaZ2H('�K'x$n) eq '��'x$n ? "ok" : "not ok", " 52\n";
print kanaZ2H('�p'x$n) eq '��'x$n ? "ok" : "not ok", " 53\n";
print kanaZ2H('�E'x$n) eq '�' x$n ? "ok" : "not ok", " 54\n";
print kanaZ2H('��'x$n) eq '��'x$n ? "ok" : "not ok", " 55\n";

print kanaZ2H('��'x$n) eq '�' x$n ? "ok" : "not ok", " 56\n";
print kanaZ2H('��'x$n) eq '��'x$n ? "ok" : "not ok", " 57\n";
print kanaZ2H('��'x$n) eq '��'x$n ? "ok" : "not ok", " 58\n";
print kanaZ2H('�E'x$n) eq '�' x$n ? "ok" : "not ok", " 59\n";
print kanaZ2H($vu x$n) eq '��'x$n ? "ok" : "not ok", " 60\n";

print ka2hi('�A'x$n) eq '��'x$n ? "ok" : "not ok", " 61\n";
print ka2hi('�K'x$n) eq '��'x$n ? "ok" : "not ok", " 62\n";
print ka2hi('�p'x$n) eq '��'x$n ? "ok" : "not ok", " 63\n";
print ka2hi('��'x$n) eq '��'x$n ? "ok" : "not ok", " 64\n";
print ka2hi('��'x$n) eq $vu x$n ? "ok" : "not ok", " 65\n";

print hi2ka('��'x$n) eq '�A'x$n ? "ok" : "not ok", " 66\n";
print hi2ka('��'x$n) eq '�K'x$n ? "ok" : "not ok", " 67\n";
print hi2ka('��'x$n) eq '�p'x$n ? "ok" : "not ok", " 68\n";
print hi2ka('��'x$n) eq '��'x$n ? "ok" : "not ok", " 69\n";
print hi2ka($vu x$n) eq '��'x$n ? "ok" : "not ok", " 70\n";

print hiXka('�A'x$n) eq '��'x$n ? "ok" : "not ok", " 71\n";
print hiXka('�K'x$n) eq '��'x$n ? "ok" : "not ok", " 72\n";
print hiXka('�p'x$n) eq '��'x$n ? "ok" : "not ok", " 73\n";
print hiXka('��'x$n) eq '��'x$n ? "ok" : "not ok", " 74\n";
print hiXka('��'x$n) eq $vu x$n ? "ok" : "not ok", " 75\n";

print hiXka('��'x$n) eq '�A'x$n ? "ok" : "not ok", " 76\n";
print hiXka('��'x$n) eq '�K'x$n ? "ok" : "not ok", " 77\n";
print hiXka('��'x$n) eq '�p'x$n ? "ok" : "not ok", " 78\n";
print hiXka('��'x$n) eq '��'x$n ? "ok" : "not ok", " 79\n";
print hiXka($vu x$n) eq '��'x$n ? "ok" : "not ok", " 80\n";

__END__
