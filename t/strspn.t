
BEGIN { $| = 1; print "1..14\n"; }
END {print "not ok 1\n" unless $loaded;}

use ShiftJIS::String qw(:all);

$^W = 1;
$loaded = 1;
print "ok 1\n";

#####

print strspn ("", "") == 0
   && strcspn("", "") == 0
   && rspan  ("", "") == 0
   && rcspan ("", "") == 0
 ? "ok" : "not ok", " 2\n";

print strspn ("", "123") == 0
   && strcspn("", "123") == 0
   && rspan  ("", "123") == 0
   && rcspan ("", "123") == 0
 ? "ok" : "not ok", " 3\n";

print strspn ("����������", "") == 0
   && strcspn("����������", "") == 5
   && rspan  ("����������", "") == 5
   && rcspan ("����������", "") == 0
 ? "ok" : "not ok", " 4\n";

print strspn ("XZ\0Z\0Y", "\0X\0YZ") == 6
   && strcspn("XZ\0Z\0Y", "\0X\0YZ") == 0
   && rspan  ("XZ\0Z\0Y", "\0X\0YZ") == 0
   && rcspan ("XZ\0Z\0Y", "\0X\0YZ") == 6
 ? "ok" : "not ok", " 5\n";

print strspn ("Perl�͖ʔ����B", "XY\0r") == 0
   && strcspn("Perl�͖ʔ����B", "XY\0r") == 2
   && rspan  ("Perl�͖ʔ����B", "XY\0r") == 9
   && rcspan ("Perl�͖ʔ����B", "XY\0r") == 3
 ? "ok" : "not ok", " 6\n";

print strspn ("+0.12345*12", "+-.0123456789") == 8
   && strcspn("+0.12345*12", "+-.0123456789") == 0
   && rspan  ("+0.12345*12", "+-.0123456789") == 9
   && rcspan ("+0.12345*12", "+-.0123456789") == 11
 ? "ok" : "not ok", " 7\n";

print strspn ("Perl�͖ʔ����B", "�Ԑ�����") == 0
   && strcspn("Perl�͖ʔ����B", "�Ԑ�����") == 6
   && rspan  ("Perl�͖ʔ����B", "�Ԑ�����") == 9
   && rcspan ("Perl�͖ʔ����B", "�Ԑ�����") == 7
 ? "ok" : "not ok", " 8\n";

print strspn("������c����n����������p��", "����������") == 3
   && rspan ("������c����n����������p��", "����������") == 13
   && strspn("������c����n����������pqr", "����������") == 3
   && rspan ("������c����n����������pqr", "����������") == 15
 ? "ok" : "not ok", " 9\n";

#####

$string = '�@�@  �@����\n��AB�@C ��x���@ �@';

print substr($string, strspn($string, ' �@'))
	eq '����\n��AB�@C ��x���@ �@'
   && substr($string, 0, strspn($string, ' �@'))
	eq '�@�@  �@'
   && substr($string, rspan($string, ' �@'))
	eq '�@ �@'
   && substr($string, 0, rspan($string, ' �@'))
	eq '�@�@  �@����\n��AB�@C ��x��'
   && substr(substr($string, 0, rspan($string, ' �@')),
	strspn($string, ' �@')) eq '����\n��AB�@C ��x��'
 ? "ok" : "not ok", " 10\n";

#####

$string = '����\n��AB�@C ��x���@ �@';

print substr($string, strspn($string, ' �@'))
	eq '����\n��AB�@C ��x���@ �@'
   && substr($string, 0, strspn($string, ' �@'))
	eq ''
   && substr($string, rspan($string, ' �@'))
	eq '�@ �@'
   && substr($string, 0, rspan($string, ' �@'))
	eq '����\n��AB�@C ��x��'
 ? "ok" : "not ok", " 11\n";

#####

$string = '�@�@  �@����\n��AB�@C ��x��';

print substr($string, strspn($string, ' �@'))
	eq '����\n��AB�@C ��x��'
   && substr($string, 0, strspn($string, ' �@'))
	eq '�@�@  �@'
   && substr($string, rspan($string, ' �@'))
	eq ''
   && substr($string, 0, rspan($string, ' �@'))
	eq '�@�@  �@����\n��AB�@C ��x��'
 ? "ok" : "not ok", " 12\n";

#####

$string = '����\n��AB�@C ��x��a';

print substr($string, strspn($string, ' �@'))
	eq '����\n��AB�@C ��x��a'
   && substr($string, 0, strspn($string, ' �@'))
	eq ''
   && substr($string, rspan($string, ' �@'))
	eq ''
   && substr($string, 0, rspan($string, ' �@'))
	eq '����\n��AB�@C ��x��a'
 ? "ok" : "not ok", " 13\n";

#####

print rspan ('+0123456789*+!', '*+!#$%') == 11
   && rspan ('�{�O�P�Q�R�S�T�U�V�W�X���{�I', '���{�I������') == 11
   && rspan ('����������������', "����������") == 0
   && rcspan('ABC������XYZ', "����������") == 6
   && rcspan('ABC�o������XYZ', "����������") == 0
 ? "ok" : "not ok", " 14\n";

1;
__END__
