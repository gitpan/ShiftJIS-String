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

$str = "�Ȃ�Ƃ�������";
print strtr(\$str,"����������", "�A�C�E�G�I") . "  " . $str
    eq "3  �Ȃ�ƃC�I�E��" ? "ok 2\n" : "not ok 2";

print strtr('���������߂ڂ��@�����Ƃ͂�', '��-��', '', 's')
    eq '�������߂ڂ��@���Ƃ�'  ? "ok 3\n" : "not ok 3";

print strtr("�������Z�q�̎g�������͌��ꂵ��", '��-��', '��', 'cs')
    eq '���́��������́�����' ? "ok 4\n" : "not ok 4";

print strtr("90 - 32 = 58", "0-9", "A-J")
    eq "JA - DC = FI" ? "ok 5\n" : "not ok 5";

print strtr("90 - 32 = 58", "0-9", "A-J", "R")
    eq "JA - 32 = 58" ? "ok 6\n" : "not ok 6";

print strtr(
    "Caesar Aether Goethe", 
    "aeoeueAeOeUe", 
    "&auml;&ouml;&ouml;&Auml;&Ouml;&Uuml;", 
    "", 
    "[aouAOU]e",
    "&[aouAOU]uml;")
  eq "C&auml;sar &Auml;ther G&ouml;the" ? "ok 7\n" : "not ok 7";

print strtr(
    "Caesar Aether Goethe", 
    [qw/ae oe ue Ae Oe Ue/], 
    [qw/&auml; &ouml; &ouml; &Auml; &Ouml; &Uuml;/]
  )  eq "C&auml;sar &Auml;ther G&ouml;the" ? "ok 8\n" : "not ok 8";

print spaceZ2H('�@���@: �@�`��@��') eq ' �� :  �`��@��'
   && spaceH2Z(' �@: �@�`��@��') eq '�@�@:�@�@�`��@��'
   ? "ok 9\n" : "not ok 9";

$str = '����������aiueoAIUEO��������{����';
$rev = '�����{�������OEUIAoeuia����������';
print $rev eq ShiftJIS::String::strrev($str)
   ? "ok 10\n" : "not ok 10";

$str = "�A�C�E�G�IABC-125pQr-xyz";

print "�A�C�E�G�I" eq ShiftJIS::String::toupper("�A�C�E�G�I")
   ? "ok 11\n" : "not ok 11\n";
print "�A�C�E�G�IABC-125PQR-XYZ" eq ShiftJIS::String::toupper($str)
   ? "ok 12\n" : "not ok 12\n";
print "�A�C�E�G�I" eq ShiftJIS::String::tolower("�A�C�E�G�I")
   ? "ok 13\n" : "not ok 13\n";
print "�A�C�E�G�Iabc-125pqr-xyz" eq ShiftJIS::String::tolower($str)
   ? "ok 14\n" : "not ok 14\n";

{
  my $digit_tr = ShiftJIS::String::trclosure(
    "1234567890-",
    "���O�l�ܘZ������Z�|"
  );

  my $frstr1 = "�d�b�F0124-45-6789\n";
  my $tostr1 = "�d�b�F�Z���l�|�l�܁|�Z������\n";
  my $frstr2 = "FAX �F0124-51-5368\n";
  my $tostr2 = "FAX �F�Z���l�|�܈�|�܎O�Z��\n";

  my $restr1 = &$digit_tr($frstr1);
  my $restr2 = &$digit_tr($frstr2);

  print $tostr1 eq $restr1 ? "ok 15\n" : "not ok 15\n";
  print $tostr2 eq $restr2 ? "ok 16\n" : "not ok 16\n";
}
