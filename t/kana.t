# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..8\n"; }
END {print "not ok 1\n" unless $loaded;}
use ShiftJIS::String qw(strtr spaceH2Z spaceZ2H);

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

  print ShiftJIS::String::kataH2Z($all) eq $hiraZ.$kataZ.$kataZ
    ? "ok" : "not ok", " 2\n";
  print ShiftJIS::String::kanaH2Z($all) eq $hiraZ.$kataZ.$kataZ
    ? "ok" : "not ok", " 3\n";
  print ShiftJIS::String::kataZ2H($all) eq $hiraZK.$kataH.$kataH
    ? "ok" : "not ok", " 4\n";
  print ShiftJIS::String::kanaZ2H($all) eq $kataH.$kataH.$kataH
    ? "ok" : "not ok", " 5\n";
  print ShiftJIS::String::hiXka($all) eq $kataZ.$hiraZ.$kataH
    ? "ok" : "not ok", " 6\n";
  print ShiftJIS::String::hi2ka($all) eq $kataZ.$kataZ.$kataH
    ? "ok" : "not ok", " 7\n";
  print ShiftJIS::String::ka2hi($all) eq $hiraZ.$hiraZ.$kataH
    ? "ok" : "not ok", " 8\n";
}
