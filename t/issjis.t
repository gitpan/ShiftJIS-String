# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..16\n"; }
END {print "not ok 1\n" unless $loaded;}
use ShiftJIS::String qw(strtr spaceH2Z spaceZ2H);
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
     print ShiftJIS::String::issjis($_)
       ? "ok" : "not ok";
     print " ", ++$n, "\n";
  }
  for(
	"�����������\x8080",
	"�ǂ��ɂ������ɂ�\x81\x39",
	"\x91\x00",
	"\xaf\xe2",
	"�����\xFF�ǂ�����",
  ){
     print ! ShiftJIS::String::issjis($_)
	? "ok" : "not ok";
     print " ", ++$n, "\n";
  }
  print ShiftJIS::String::issjis("��", "P", "", "�ݼ� test")
	? "ok 15\n" : "not ok 15\n";
  print ! ShiftJIS::String::issjis("���{","��kanji","\xA0")
	? "ok 16\n" : "not ok 16\n";
}
