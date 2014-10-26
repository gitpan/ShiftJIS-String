# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

BEGIN { $| = 1; print "1..17\n"; }
END {print "not ok 1\n" unless $loaded;}

use ShiftJIS::String qw(:all);

$^W = 1;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

$str = "�Ȃ�Ƃ�������";
print strtr(\$str,"����������", "�A�C�E�G�I") . "  " . $str
    eq "3  �Ȃ�ƃC�I�E��" ? "ok" : "not ok", " 2\n";

print strtr('���������߂ڂ��@�����Ƃ͂�', '��-��', '', 's')
    eq '�������߂ڂ��@���Ƃ�'  ? "ok" : "not ok", " 3\n";

print strtr("�������Z�q�̎g�������͌��ꂵ��", '��-��', '��', 'cs')
    eq '���́��������́�����' ? "ok" : "not ok", " 4\n";

print strtr("90 - 32 = 58", "0-9", "A-J")
    eq "JA - DC = FI" ? "ok" : "not ok", " 5\n";

print strtr("90 - 32 = 58", "0-9", "A-J", "R")
    eq "JA - 32 = 58" ? "ok" : "not ok", " 6\n";

print strtr(
    "Caesar Aether Goethe", 
    "aeoeueAeOeUe", 
    "&auml;&ouml;&ouml;&Auml;&Ouml;&Uuml;", 
    "", 
    "[aouAOU]e",
    "&[aouAOU]uml;")
  eq "C&auml;sar &Auml;ther G&ouml;the" ? "ok" : "not ok", " 7\n";

print strtr(
    "Caesar Aether Goethe", 
    [qw/ae oe ue Ae Oe Ue/], 
    [qw/&auml; &ouml; &ouml; &Auml; &Ouml; &Uuml;/]
  )  eq "C&auml;sar &Auml;ther G&ouml;the" ? "ok" : "not ok", " 8\n";

print spaceZ2H('�@���@: �@�`��@��') eq ' �� :  �`��@��'
   && spaceH2Z(' �@: �@�`��@��') eq '�@�@:�@�@�`��@��'
   ? "ok" : "not ok", " 9\n";

$str = '����������aiueoAIUEO��������{����';
$rev = '�����{�������OEUIAoeuia����������';
print $rev eq strrev($str)
   ? "ok" : "not ok", " 10\n";

$str = "�A�C�E�G�IABC-125pQr-xyz";

print "�A�C�E�G�I" eq toupper("�A�C�E�G�I")
   ? "ok" : "not ok", " 11\n";
print "�A�C�E�G�IABC-125PQR-XYZ" eq toupper($str)
   ? "ok" : "not ok", " 12\n";
print "�A�C�E�G�I" eq tolower("�A�C�E�G�I")
   ? "ok" : "not ok", " 13\n";
print "�A�C�E�G�Iabc-125pqr-xyz" eq tolower($str)
   ? "ok" : "not ok", " 14\n";

{
  my $digit_tr = trclosure(
    "1234567890-",
    "���O�l�ܘZ������Z�|"
  );

  my $frstr1 = "�d�b�F0124-45-6789\n";
  my $tostr1 = "�d�b�F�Z���l�|�l�܁|�Z������\n";
  my $frstr2 = "FAX �F0124-51-5368\n";
  my $tostr2 = "FAX �F�Z���l�|�܈�|�܎O�Z��\n";

  my $restr1 = &$digit_tr($frstr1);
  my $restr2 = &$digit_tr($frstr2);

  print $tostr1 eq $restr1 ? "ok" : "not ok", " 15\n";
  print $tostr2 eq $restr2 ? "ok" : "not ok", " 16\n";
}

$str = '�v���O���~���O Perl';
$len = length(substr($str, 2 + index($str, '���~')));
print $len == 7 ? "ok" : "not ok", " 17\n";
