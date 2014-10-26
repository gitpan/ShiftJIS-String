
BEGIN { $| = 1; print "1..101\n"; }
END {print "not ok 1\n" unless $loaded;}

use ShiftJIS::String qw(:kana :H2Z :Z2H toupper tolower);

$^W = 1;
$loaded = 1;
print "ok 1\n";

#####

{
  for $ary (
    [ \&kanaZ2H, qw/ �E�J�@�E�J�B�E�J�E�J�F�E�J�H   �ާ�ި�޳ު�ޫ  14 / ],
    [ \&kataZ2H, qw/ �E�J�@�E�J�B�E�J�E�J�F�E�J�H   �ާ�ި�޳ު�ޫ  14 / ],
    [ \&hiraZ2H, '�E�J�@�E�J�B�E�J�E�J�F�E�J�H',
                 '�Eރ@�EރB�EރEރF�EރH',  5],
    [ \&kanaZ2H, qw/ ���J�����J�����J���J�����J��   �ާ�ި�޳ު�ޫ   9 / ],
    [ \&hiraZ2H, qw/ ���J�����J�����J���J�����J��   �ާ�ި�޳ު�ޫ   9 / ],
    [ \&kataZ2H, '���J�����J�����J���J�����J��',
                 '���J�����J�����J���J�����J��',  0 ],
    [ \&kanaH2Z, qw/ ���񂿂ɂ� ���񂿂ɂ�   0 / ],
    [ \&kanaH2Z, qw/ �����      �R���j�`�n   5 / ],
    [ \&kanaH2Z, qw/ �߰�       �p�[��       3 / ],
    [ \&kanaH2Z, qw/ ��۸��ь��� �v���O�������� 5 / ],
    [ \&kanaH2Z, qw/ ���޸��    �r�_�N�I��   5 / ],
    [ \&kanaH2Z, qw/ �߷߸߹ߺ� �J�K�L�K�N�K�P�K�R�K 10 / ],
    [ \&kanaH2Z, qw/ ��ޡ       ���J�B       2 / ],
    [ \&kanaH2Z, qw/ �ޡ        �G�J�B       3 / ],
    [ \&kanaH2Z, qw/ A�ޡB      A���BB       2 / ],
    [ \&kataH2Z, qw/ ���񂿂ɂ� ���񂿂ɂ�   0 / ],
    [ \&kataH2Z, qw/ �����      �R���j�`�n   5 / ],
    [ \&kataH2Z, qw/ �߰�       �p�[��       3 / ],
    [ \&hiraH2Z, qw/ ���񂿂ɂ� ���񂿂ɂ�   0 / ],
    [ \&hiraH2Z, qw/ �����      ����ɂ���   5 / ],
    [ \&hiraH2Z, qw/ �߰�       �ρ[��       3 / ],
    [ \&tolower, qw/ ��������ABCD���񂿂ɂ� ��������abcd���񂿂ɂ�   4 / ],
    [ \&tolower, qw/ �A���t�@�x�b�g���܂܂Ȃ�  �A���t�@�x�b�g���܂܂Ȃ� 0 / ],
    [ \&tolower, qw/ Perl_Module    perl_module   2 / ],
    [ \&tolower, qw/ �o���������g�� �o���������g�� 0 / ],
  ) {
    $str = $ary->[1];
    print &{ $ary->[0] }($str)  eq $ary->[2]
	? "ok" : "not ok", " ", ++$loaded, "\n";
    print $str eq $ary->[1]
	? "ok" : "not ok", " ", ++$loaded, "\n";
    print &{ $ary->[0] }(\$str) eq $ary->[3]
	? "ok" : "not ok", " ", ++$loaded, "\n";
    print $str eq $ary->[2]
	? "ok" : "not ok", " ", ++$loaded, "\n";
  }
}

