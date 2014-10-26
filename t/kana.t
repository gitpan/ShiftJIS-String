# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

BEGIN { $| = 1; print "1..20\n"; }
END {print "not ok 1\n" unless $loaded;}

use ShiftJIS::String qw(:kana :H2Z :Z2H toupper tolower);

$^W = 1;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

{
my $kataH
 = '���������������������������������������������������������������'
 . '�޷޸޹޺޻޼޽޾޿������������������������������߳�';

my $kataZ
 = '�B�u�v�A�E���@�B�D�F�H�������b�[�A�C�E�G�I�J�L�N�P�R�T�V�X�Z�\�^'
 . '�`�c�e�g�i�j�k�l�m�n�q�t�w�z�}�~���������������������������J�K'
 . '�K�M�O�Q�S�U�W�Y�[�]�_�a�d�f�h�o�r�u�x�{�p�s�v�y�|��';

my $hiraZ
 = '�B�u�v�A�E������������������[��������������������������������'
 . '���ĂƂȂɂʂ˂̂͂Ђӂւق܂݂ނ߂������������J�K'
 . '�������������������������Âłǂ΂тԂׂڂς҂Ղ؂ۂ��J';

my $hiraZK
 = '�������������������������������������������������������'
 . '���ĂƂȂɂʂ˂̂͂Ђӂւق܂݂ނ߂��������������'
 . '�������������������������Âłǂ΂тԂׂڂς҂Ղ؂ۂ��J';

my $all = $hiraZ.$kataZ.$kataH;

# ���샎���Ȃǂ̓e�X�g���珜�O�B

  my $ary;
  foreach $ary (
    [ \&kataH2Z,  $hiraZ.$kataZ.$kataZ,  89 ],
    [ \&kanaH2Z,  $hiraZ.$kataZ.$kataZ,  89 ],
    [ \&kataZ2H,  $hiraZK.$kataH.$kataH, 97 ],
    [ \&kanaZ2H,  $kataH.$kataH.$kataH, 178 ],
    [ \&hiXka,    $kataZ.$hiraZ.$kataH, 162 ],
    [ \&hi2ka,    $kataZ.$kataZ.$kataH,  81 ],
    [ \&ka2hi,    $hiraZ.$hiraZ.$kataH,  81 ],
    [ \&spaceH2Z, $hiraZ.$kataZ.$kataH,   0 ],
    [ \&spaceZ2H, $hiraZ.$kataZ.$kataH,   0 ],
    [ \&toupper,  $hiraZ.$kataZ.$kataH,   0 ],
    [ \&tolower,  $hiraZ.$kataZ.$kataH,   0 ],
  ) {
    my $ng = 0;
    my $str = $all;
    $ng++ unless &{ $ary->[0] }($all) eq $ary->[1];
    $ng++ unless &{ $ary->[0] }(\$str) eq $ary->[2];
    $ng++ unless $str eq $ary->[1];
    print $ng == 0 ? "ok" : "not ok", " ", ++$loaded, "\n";
  }
}

print 1
  && hiXka('���삩���A�������������E') eq '�������J�P�����J���삩����'
  && ka2hi('���삩���A�������������E') eq '���삩�������J���삩����'
  && hi2ka('���삩���A�������������E') eq '�������J�P�A�������������E'
  && kanaH2Z('�ާ�ި�޳ު�ޫ�ެ�ޭ�ޮ')  eq '���@���B�����F���H������������'
  && kataH2Z('�ާ�ި�޳ު�ޫ�ެ�ޭ�ޮ')  eq '���@���B�����F���H������������'
  && kanaZ2H('���@���B�����F���H������������') eq '�ާ�ި�޳ު�ޫ�ެ�ޭ�ޮ'
  && kataZ2H('���@���B�����F���H������������') eq '�ާ�ި�޳ު�ޫ�ެ�ޭ�ޮ'
  && kanaZ2H('�E�J�@�E�J�B�E�J�E�J�F�E�J�H')   eq '�ާ�ި�޳ު�ޫ'
  && kanaZ2H('�E�J�@�E�J�B�E�J�E�J�F�E�J�H')   eq '�ާ�ި�޳ު�ޫ'
  && kanaZ2H('���J�����J�����J���J�����J��')   eq '�ާ�ި�޳ު�ޫ'
  && kataZ2H('���J�����J�����J���J�����J��') eq '���J�����J�����J���J�����J��'
    ? "ok" : "not ok", " ", ++$loaded, "\n";

{
  my $lo = 'abcdefghijklmnopqrstuvwxyz';
  my $up = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  my $sp = ' ';
  my $zp = '�@';
  my $all = "$sp$lo$zp$up$sp$lo";

  my $ary;
  foreach $ary (
    [ \&toupper,  "$sp$up$zp$up$sp$up", 52 ],
    [ \&tolower,  "$sp$lo$zp$lo$sp$lo", 26 ],
    [ \&spaceH2Z, "$zp$lo$zp$up$zp$lo",  2 ],
    [ \&spaceZ2H, "$sp$lo$sp$up$sp$lo",  1 ],
  ) {
    my $ng = 0;
    my $str = $all;
    $ng++ unless &{ $ary->[0] }($all) eq $ary->[1];
    $ng++ unless &{ $ary->[0] }(\$str) eq $ary->[2];
    $ng++ unless $str eq $ary->[1];
    print $ng == 0 ? "ok" : "not ok", " ", ++$loaded, "\n";
  }
}

{
  my $ng = 0;
  my $ary;
  for $ary (
    [ qw/ ���񂿂ɂ� ���񂿂ɂ�   0 / ],
    [ qw/ �����      �R���j�`�n   5 / ],
    [ qw/ �߰�       �p�[��       3 / ],
    [ qw/ ��۸��ь��� �v���O�������� 5 / ],
    [ qw/ ���޸��    �r�_�N�I��   5 / ],
    [ qw/ �߷߸߹ߺ� �J�K�L�K�N�K�P�K�R�K 10 / ],
    [ qw/ ��ޡ       ���J�B       2 / ],
    [ qw/ �ޡ        �G�J�B       3 / ],
    [ qw/ A�ޡB      A���BB       2 / ],
  ) {
    my $str = $ary->[0];
    $ng++ unless kanaH2Z($str)  eq $ary->[1];
    $ng++ unless $str eq $ary->[0];
    $ng++ unless kanaH2Z(\$str) eq $ary->[2];
    $ng++ unless $str eq $ary->[1];
  }
  print $ng == 0 ? "ok" : "not ok", " ", ++$loaded, "\n";
}


{
  my $ng = 0;
  my $ary;
  for $ary (
    [ qw/ ��������ABCD���񂿂ɂ� ��������abcd���񂿂ɂ�   4 / ],
    [ qw/ �A���t�@�x�b�g���܂܂Ȃ�  �A���t�@�x�b�g���܂܂Ȃ� 0 / ],
    [ qw/ Perl_Module    perl_module   2 / ],
    [ qw/ �o���������g�� �o���������g�� 0 / ],
  ) {
    my $str = $ary->[0];
    $ng++ unless tolower($str)  eq $ary->[1];
    $ng++ unless $str eq $ary->[0];
    $ng++ unless tolower(\$str) eq $ary->[2];
    $ng++ unless $str eq $ary->[1];
  }
  print $ng == 0 ? "ok" : "not ok", " ", ++$loaded, "\n";
}

sub stricmp { toupper($_[0]) cmp toupper($_[1]) }

print 1
  &&  0 == stricmp('', '')
  && -1 == stricmp('', "\0")
  &&  0 == stricmp('A', 'a')
  && -1 == stricmp('�u�K', '�u�k')
  &&  0 == stricmp('�v���O���~���OPerl',  '�v���O���~���OPERL')
  && -1 == stricmp('�v���O���~���OPerl',  '�v���O���~���oPERL')
  ? "ok" : "not ok", " 20\n";

