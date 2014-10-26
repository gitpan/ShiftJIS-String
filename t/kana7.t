
BEGIN { $| = 1; print "1..7\n"; }
END {print "not ok 1\n" unless $loaded;}

use ShiftJIS::String qw(toupper tolower);

$^W = 1;
$loaded = 1;
print "ok 1\n";

#####

sub stricmp { toupper($_[0]) cmp toupper($_[1]) }

print  0 == stricmp('', '')
  ? "ok" : "not ok", " ", ++$loaded, "\n";
print -1 == stricmp('', "\0")
  ? "ok" : "not ok", " ", ++$loaded, "\n";
print  0 == stricmp('A', 'a')
  ? "ok" : "not ok", " ", ++$loaded, "\n";
print -1 == stricmp('�u�K', '�u�k')
  ? "ok" : "not ok", " ", ++$loaded, "\n";
print  0 == stricmp('�v���O���~���OPerl',  '�v���O���~���OPERL')
  ? "ok" : "not ok", " ", ++$loaded, "\n";
print -1 == stricmp('�v���O���~���OPerl',  '�v���O���~���oPERL')
  ? "ok" : "not ok", " ", ++$loaded, "\n";

