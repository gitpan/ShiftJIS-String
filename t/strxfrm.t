# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

BEGIN { $| = 1; print "1..7\n"; }
END {print "not ok 1\n" unless $loaded;}

use ShiftJIS::String qw(:cmp mkrange);

$^W = 1;
$loaded = 1;
print "ok 1\n";

sub str_cmp { strxfrm($_[0]) cmp strxfrm($_[1]) }
sub str_EQ  { strxfrm($_[0]) eq  strxfrm($_[1]) }
sub str_NE  { strxfrm($_[0]) ne  strxfrm($_[1]) }
sub str_LT  { strxfrm($_[0]) lt  strxfrm($_[1]) }
sub str_LE  { strxfrm($_[0]) le  strxfrm($_[1]) }
sub str_GT  { strxfrm($_[0]) gt  strxfrm($_[1]) }
sub str_GE  { strxfrm($_[0]) ge  strxfrm($_[1]) }

######################### End of black magic.

print 1
  && str_cmp('',   'A')  < 0
  && str_cmp('A',  'a')  < 0
  && str_cmp('a',  '�')  < 0
  && str_cmp('�',  '�`') < 0
  && str_cmp('�`', '��') < 0
  && str_cmp('��', '�A') < 0
  && str_cmp('�A', '��') < 0
  && str_cmp('��', '�r') < 0
  && str_cmp('�r', '��') < 0
  && str_cmp('��', '�') < 0
  ? "ok" : "not ok", " 2\n";

print 1
  && str_cmp(123, 123) == 0
  && str_cmp(12,  11)  == 1
  && str_cmp(11,  12)  == -1
  && str_EQ(123, 123) eq (123 eq 123)
  && str_EQ(123, 124) eq (123 eq 124)
  && str_NE(123, 123) eq (123 ne 123)
  && str_NE(123, 124) eq (123 ne 124)
  ? "ok" : "not ok", " 3\n";

my $prev = '';
my $here = '';
my @char = mkrange("\0-\xfc\xfc");
my @ret = (0) x 7;
my $NG1 = 0;
my $NG2 = 0;
foreach $here (@char) {
    ++$NG1 unless str_cmp($prev, $here) < 0;
    ++$NG2 unless str_LE($prev, $here);
    $prev = $here;
}
print $NG1 == 0 ? "ok" : "not ok", " 4\n";
print $NG2 == 0 ? "ok" : "not ok", " 5\n";

print 1
  && str_cmp('', '') == 0
  && str_EQ('', '')
  && !str_NE('', '')
  && str_LE('', '')
  && !str_LT('', '')
  && str_GE('', '')
  && !str_GT('', '')
  && str_cmp('', "\0") == -1
  && !str_EQ('', "\0")
  && str_NE('', "\0")
  && str_LE('', "\0")
  && str_LT('', "\0")
  && !str_GE('', "\0")
  && !str_GT('', "\0")
  && str_cmp("\0", '') == 1
  && !str_EQ("\0", '')
  && str_NE("\0", '')
  && !str_LT("\0", '')
  && !str_LE("\0", '')
  && str_GT("\0", '')
  && str_GE("\0", '')
  && str_cmp("\0", "\0") == 0
  && str_EQ("\0", "\0")
  && !str_NE("\0", "\0")
  && str_LE("\0", "\0")
  && !str_LT("\0", "\0")
  && str_GE("\0", "\0")
  && !str_GT("\0", "\0")
  && str_cmp("", 1) == -1
  && str_cmp(21, 11) == 1
  ? "ok" : "not ok", " 6\n";

print 1
  && str_NE('ABC',  'ABz')
  && str_LT('ABC',  'ABz')
  && str_GT('����', '����')
  && str_EQ('������', '������')
  && str_LT('���������', '��������')
  && str_LT("����\xA1", "����\x9D\x80")
  && str_GT("����\x82\xA1", "����\x82\x9D")
  && str_cmp("��\0׃�", "��\0���") == -1
  ? "ok" : "not ok", " 7\n";

