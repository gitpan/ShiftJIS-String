
BEGIN { $| = 1; print "1..16\n"; }
END {print "not ok 1\n" unless $loaded;}

use ShiftJIS::String qw(issjis);
$^W = 1;
$loaded = 1;
print "ok 1\n";

#####

{
  $n = 1;
  for (
	"�����e�X�g",
	"abc",
	"�����",
	"�߰�=Perl",
	"\001\002\003\000\n",
	"",
	" ",
	'�@',
  ){
     print issjis($_) ? "ok" : "not ok", " ", ++$n, "\n";
  }
  for (
	"�����������\x8080",
	"�ǂ��ɂ������ɂ�\x81\x39",
	"\x91\x00",
	"\xaf\xe2",
	"�����\xFF�ǂ�����",
  ){
     print ! issjis($_) ? "ok" : "not ok", " ", ++$n, "\n";
  }
  print  issjis("��", "P", "", "�ݼ� test") ? "ok" : "not ok", " ", ++$n, "\n";
  print !issjis("���{","��kanji","\xA0") ? "ok" : "not ok", " ", ++$n, "\n";
}

1;
__END__
