# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

BEGIN { $| = 1; print "1..7\n"; }
END {print "not ok 1\n" unless $loaded;}

use ShiftJIS::String qw(:cmp mkrange);

$^W = 1;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

print 1
  && strcmp('',   'A')  < 0
  && strcmp('A',  'a')  < 0
  && strcmp('a',  'ｱ')  < 0
  && strcmp('ｱ',  'Ａ') < 0
  && strcmp('Ａ', 'あ') < 0
  && strcmp('あ', 'ア') < 0
  && strcmp('ア', '亜') < 0
  && strcmp('亜', '腕') < 0
  && strcmp('腕', '弌') < 0
  && strcmp('弌', '熙') < 0
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
  && strGT('あお', 'あい')
  && strEQ('あおい', 'あおい')
  && strLT('ああｱ漢字', 'ああ漢字')
  && strLT("ああ\xA1", "ああ\x9D\x80")
  && strGT("ああ\x82\xA1", "ああ\x82\x9D")
  && strcmp("あ\0ﾗラ", "あ\0ラﾗ") == -1
  ? "ok" : "not ok", " 7\n";
