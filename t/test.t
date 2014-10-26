# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

BEGIN { $| = 1; print "1..20\n"; }
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

print strtr("90 - 32 = 58", "0-9", "A-J") eq "JA - DC = FI"
   && strtr("90 - 32 = 58", "0-9", "A-J", "R") eq "JA - 32 = 58"
    ? "ok" : "not ok", " 5\n";

print strtr("A\0BC\0\0", "A\0C\0", "XY\0K") eq "XYB\0YY"
   && strtr("\0\0\0AA", "\0", "", "cd") eq "\0\0\0"
   && strtr("\0\0V\0AA", "\0", "", "d") eq "VAA"
 ? "ok" : "not ok", " 6\n";

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

print strrev($str) eq '�����{�������OEUIAoeuia����������'
   && strrev("")   eq ""
   && strrev(0)    eq  0
   && strrev(1)    eq  1
   && strrev("1")  eq "1"
   && strrev("��") eq "��"
   && strrev("����") eq "����"
   && strrev("A��")  eq "��A"
   && strrev("��A")  eq "A��"
   && strrev("�tA-\0!\0") eq "\0!\0-A�t"
   ? "ok" : "not ok", " 10\n";

$str = "0123�A�C�E�G�I�����";

print $str eq toupper($str)
   && $str eq tolower($str)
   ? "ok" : "not ok", " 11\n";

$str = "�A�C�E�G�IABC-125pQr-xyz";
print "�A�C�E�G�IABC-125PQR-XYZ" eq toupper($str)
   && "�A�C�E�G�Iabc-125pqr-xyz" eq tolower($str)
   ? "ok" : "not ok", " 12\n";

print 1
  && toupper("")  eq ""
  && tolower("")  eq ""
  && toupper(0)   eq  0
  && tolower(0)   eq  0
  && toupper(12)  eq 12
  && tolower(12)  eq 12
  && toupper(-41) eq -41
  && tolower(-41) eq -41
  ? "ok" : "not ok", " 13\n";

print 1
  && hi2ka("")   eq ""
  && ka2hi("")   eq ""
  && hiXka("")   eq ""
  && kanaH2Z("") eq ""
  && kataH2Z("") eq ""
  && spaceH2Z("") eq ""
  && kanaZ2H("") eq ""
  && kataZ2H("") eq ""
  && spaceZ2H("") eq ""
  && hi2ka(0)   eq 0
  && ka2hi(0)   eq 0
  && hiXka(0)   eq 0
  && kanaH2Z(0) eq 0
  && kataH2Z(0) eq 0
  && spaceH2Z(0) eq 0
  && kanaZ2H(0) eq 0
  && kataZ2H(0) eq 0
  && spaceZ2H(0) eq 0
  && hi2ka(1)   eq 1
  && ka2hi(1)   eq 1
  && hiXka(1)   eq 1
  && kanaH2Z(1) eq 1
  && kataH2Z(1) eq 1
  && spaceH2Z(1) eq 1
  && kanaZ2H(1) eq 1
  && kataZ2H(1) eq 1
  && spaceZ2H(1) eq 1
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

print strspn("XZ\0Z\0Y", "\0X\0YZ") == 6
  &&  strcspn("Perl�͖ʔ����B", "XY\0r") == 2
  &&  strspn("+0.12345*12", "+-.0123456789") == 8
  &&  strcspn("Perl�͖ʔ����B", "�Ԑ�����") == 6
  &&  strspn("", "123") == 0
  &&  strcspn("", "123") == 0
  &&  strspn("����������", "") == 0
  &&  strcspn("����������", "") == 5
 ? "ok" : "not ok", " 18\n";

print strtr(
    "&lt;B&gt;&apos;&amp;&plusmn; &quot;&auml;&quot;&lt;/B&gt;",
    "&apos;&quot;&amp;&lt;&gt;",
    q|'"&<>|,
    "",
    "&[A-Za-z]+;")
  eq qq|<B>'&&plusmn; "&auml;"</B>| ? "ok" : "not ok", " 19\n";

print strtr(
    "Caesar Aether Goethe",
    "aeoeueAeOeUe",
    "",
    "d",
    "[aouAOU]e",
    "")
  eq "Csar ther Gthe" ? "ok" : "not ok", " 20\n";

