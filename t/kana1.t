
BEGIN { $| = 1; print "1..53\n"; }
END {print "not ok 1\n" unless $loaded;}

use ShiftJIS::String qw(:kana :H2Z :Z2H toupper tolower);

$^W = 1;
$loaded = 1;
print "ok 1\n";

#####

{
  my $kataH = '�������������������������������������������������������'
	    . '�޷޸޹޺޻޼޽޾޿������������������������������߳�';

  my $kataZ = '���@�B�D�F�H�������b�A�C�E�G�I�J�L�N�P�R�T�V�X�Z�\�^'
	    . '�`�c�e�g�i�j�k�l�m�n�q�t�w�z�}�~��������������������������'
	    . '�K�M�O�Q�S�U�W�Y�[�]�_�a�d�f�h�o�r�u�x�{�p�s�v�y�|��';

  my $hiraZ = '�������������������������������������������������'
	    . '���ĂƂȂɂʂ˂̂͂Ђӂւق܂݂ނ߂������������'
	    . '�������������������������Âłǂ΂тԂׂڂς҂Ղ؂ۂ��J';

  my $all = $hiraZ.$kataZ.$kataH;

  foreach $ary (
    [ \&kataH2Z,  $hiraZ.$kataZ.$kataZ,  81 ],
    [ \&kanaH2Z,  $hiraZ.$kataZ.$kataZ,  81 ],
    [ \&hiraH2Z,  $hiraZ.$kataZ.$hiraZ,  81 ],
    [ \&kataZ2H,  $hiraZ.$kataH.$kataH,  81 ],
    [ \&kanaZ2H,  $kataH.$kataH.$kataH, 162 ],
    [ \&hiraZ2H,  $kataH.$kataZ.$kataH,  81 ],
    [ \&hiXka,    $kataZ.$hiraZ.$kataH, 162 ],
    [ \&hi2ka,    $kataZ.$kataZ.$kataH,  81 ],
    [ \&ka2hi,    $hiraZ.$hiraZ.$kataH,  81 ],
    [ \&spaceH2Z, $hiraZ.$kataZ.$kataH,   0 ],
    [ \&spaceZ2H, $hiraZ.$kataZ.$kataH,   0 ],
    [ \&toupper,  $hiraZ.$kataZ.$kataH,   0 ],
    [ \&tolower,  $hiraZ.$kataZ.$kataH,   0 ],
  ) {
    $str = $all;
    print &{ $ary->[0] }($str) eq $ary->[1]
	? "ok" : "not ok", " ", ++$loaded, "\n";
    print $str eq $all
	? "ok" : "not ok", " ", ++$loaded, "\n";
    print &{ $ary->[0] }(\$str) eq $ary->[2]
	? "ok" : "not ok", " ", ++$loaded, "\n";
    print $str eq $ary->[1]
	? "ok" : "not ok", " ", ++$loaded, "\n";
  }
}

