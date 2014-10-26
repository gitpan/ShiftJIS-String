
BEGIN { $| = 1; print "1..53\n"; }
END {print "not ok 1\n" unless $loaded;}

use ShiftJIS::String qw(:kana :H2Z :Z2H toupper tolower);

$^W = 1;
$loaded = 1;
print "ok 1\n";

#####

{
  my $wiwewakake = '���삩���A�������������E�T�U�R�S';

  foreach $ary (
    [ \&kataH2Z,  '���삩���A�������������E�T�U�R�S',    0 ],
    [ \&kanaH2Z,  '���삩���A�������������E�T�U�R�S',    0 ],
    [ \&hiraH2Z,  '���삩���A�������������E�T�U�R�S',    0 ],
    [ \&kataZ2H,  '���삩����޲�ܶ���T�U�R�S',           8 ],
    [ \&kanaZ2H,  '��ܶ���޲�ܶ���T�U�R�S',               13 ],
    [ \&hiraZ2H,  '��ܶ��A�������������E�T�U�R�S',         5 ],
    [ \&hiXka,    '�������J�P�����J���삩�����R�S�T�U', 17 ],
    [ \&hi2ka,    '�������J�P�A�������������E�R�S�R�S',    7 ],
    [ \&ka2hi,    '���삩�������J���삩�����T�U�T�U', 10 ],
    [ \&spaceH2Z, '���삩���A�������������E�T�U�R�S',    0 ],
    [ \&spaceZ2H, '���삩���A�������������E�T�U�R�S',    0 ],
    [ \&toupper,  '���삩���A�������������E�T�U�R�S',    0 ],
    [ \&tolower,  '���삩���A�������������E�T�U�R�S',    0 ],
  ) {
    $str = $wiwewakake;
    print &{ $ary->[0] }($str) eq $ary->[1]
	? "ok" : "not ok", " ", ++$loaded, "\n";
    print $str eq $wiwewakake
	? "ok" : "not ok", " ", ++$loaded, "\n";
    print &{ $ary->[0] }(\$str) eq $ary->[2]
	? "ok" : "not ok", " ", ++$loaded, "\n";
    print $str eq $ary->[1]
	? "ok" : "not ok", " ", ++$loaded, "\n";
  }
}
