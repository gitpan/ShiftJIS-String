
BEGIN { $| = 1; print "1..7\n"; }
END {print "not ok 1\n" unless $loaded;}

use ShiftJIS::String qw(:cmp mkrange);

$^W = 1;
$loaded = 1;
print "ok 1\n";

#####

print 1
  && strcmp('',   'A')  < 0
  && strcmp('A',  'a')  < 0
  && strcmp('a',  '±')  < 0
  && strcmp('±',  '‚`') < 0
  && strcmp('‚`', '‚ ') < 0
  && strcmp('‚ ', 'ƒA') < 0
  && strcmp('ƒA', 'ˆŸ') < 0
  && strcmp('ˆŸ', '˜r') < 0
  && strcmp('˜r', '˜Ÿ') < 0
  && strcmp('˜Ÿ', 'ê¤') < 0
  ? "ok" : "not ok", " 2\n";

print 1
  && strcmp(123, 123) == 0
  && strcmp(12,  11)  == 1
  && strcmp(11,  12)  == -1
  && strEQ(123, 123) eq (123 eq 123)
  && strEQ(123, 124) eq (123 eq 124)
  && strNE(123, 123) eq (123 ne 123)
  && strNE(123, 124) eq (123 ne 124)
  ? "ok" : "not ok", " 3\n";

my $prev = '';
my $here = '';
my @char = mkrange("\0-\xfc\xfc");
my @ret = (0) x 7;
my $NG1 = 0;
my $NG2 = 0;
foreach $here (@char) {
    ++$NG1 unless strcmp($prev, $here) < 0;
    ++$NG2 unless strLE($prev, $here);
    $prev = $here;
}
print $NG1 == 0 ? "ok" : "not ok", " 4\n";
print $NG2 == 0 ? "ok" : "not ok", " 5\n";

print 1
  && strcmp('', '') == 0
  && strEQ('', '')
  && !strNE('', '')
  && strLE('', '')
  && !strLT('', '')
  && strGE('', '')
  && !strGT('', '')
  && strcmp('', "\0") == -1
  && !strEQ('', "\0")
  && strNE('', "\0")
  && strLE('', "\0")
  && strLT('', "\0")
  && !strGE('', "\0")
  && !strGT('', "\0")
  && strcmp("\0", '') == 1
  && !strEQ("\0", '')
  && strNE("\0", '')
  && !strLT("\0", '')
  && !strLE("\0", '')
  && strGT("\0", '')
  && strGE("\0", '')
  && strcmp("\0", "\0") == 0
  && strEQ("\0", "\0")
  && !strNE("\0", "\0")
  && strLE("\0", "\0")
  && !strLT("\0", "\0")
  && strGE("\0", "\0")
  && !strGT("\0", "\0")
  && strcmp("", 1) == -1
  && strcmp(21, 11) == 1
  ? "ok" : "not ok", " 6\n";

print 1
  && strNE('ABC',  'ABz')
  && strLT('ABC',  'ABz')
  && strGT('‚ ‚¨', '‚ ‚¢')
  && strEQ('‚ ‚¨‚¢', '‚ ‚¨‚¢')
  && strLT('‚ ‚ ±Š¿Žš', '‚ ‚ Š¿Žš')
  && strLT("‚ ‚ \xA1", "‚ ‚ \x9D\x80")
  && strGT("‚ ‚ \x82\xA1", "‚ ‚ \x82\x9D")
  && strcmp("‚ \0×ƒ‰", "‚ \0ƒ‰×") == -1
  ? "ok" : "not ok", " 7\n";

1;

__END__
