# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

BEGIN { $| = 1; print "1..16\n"; }
END {print "not ok 1\n" unless $loaded;}

use ShiftJIS::String qw(issjis);
$^W = 1;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.
{
  my $v;
  my $n = 1;
  for(
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
  for(
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
