
BEGIN { $| = 1; print "1..16\n"; }
END {print "not ok 1\n" unless $loaded;}

use ShiftJIS::String qw(:all);

$^W = 1;
$loaded = 1;
print "ok 1\n";

if ($] < 5.005) {
  foreach(2..16) { print "ok $_\n"; }
  exit;
}

#####

print 'abc���`�a�bxyz' eq tolower 'AbC���`�a�bXYz'
  ? "ok" : "not ok", " 2\n";

print '' eq toupper ''
  ? "ok" : "not ok", " 3\n";

print length '' eq '0'
  ? "ok" : "not ok", " 4\n";

print 9 == length 'Perl�̃e�X�g.'
  ? "ok" : "not ok", " 5\n";

print '.�g�X�e��lreP' eq strrev 'Perl�̃e�X�g.'
  ? "ok" : "not ok", " 6\n";

print '����̓p�[���̃e�X�g�ł�' eq kanaH2Z '������߰ق�ÃXĂł�'
  ? "ok" : "not ok", " 7\n";

print kataZ2H '����̓p����̃e�X�g�ł�' eq '������߰ق�ýĂł�'
  ? "ok" : "not ok", " 8\n";

print '����߰��ý��޽' eq kanaZ2H '����̓p����̃e�X�g�ł�'
  ? "ok" : "not ok", " 9\n";

print '�R���n�ρ[��m�Ă��ƃf�X' eq hiXka '����̓p�[���̃e�X�g�ł�'
  ? "ok" : "not ok", " 10\n";

print hi2ka '����̓p�[���̃e�X�g�ł�' eq '�R���n�p�[���m�e�X�g�f�X'
  ? "ok" : "not ok", " 11\n";

print ka2hi '����̓p�[����ý�g�ł�'   eq '����͂ρ[���ý�Ƃł�'
  ? "ok" : "not ok", " 12\n";

print spaceH2Z ' ���@ �@��  ' eq '�@���@�@�@���@�@'
  ? "ok" : "not ok", " 13\n";

print spaceZ2H ' ���@ �@��  ' eq ' ��   ��  '
  ? "ok" : "not ok", " 14\n";

print spaceH2Z '����' eq '����'
  ? "ok" : "not ok", " 15\n";

print spaceZ2H '����' eq '����'
  ? "ok" : "not ok", " 16\n";

1;
__END__
