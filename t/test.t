# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..16\n"; }
END {print "not ok 1\n" unless $loaded;}
use ShiftJIS::String qw(strtr spaceH2Z spaceZ2H);

$^W = 1;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

$str = "なんといおうか";
print strtr(\$str,"あいうえお", "アイウエオ") . "  " . $str
    eq "3  なんとイオウか" ? "ok 2\n" : "not ok 2";

print strtr('おかかうめぼし　ちちとはは', 'ぁ-ん', '', 's')
    eq 'おかうめぼし　ちとは'  ? "ok 3\n" : "not ok 3";

print strtr("条件演算子の使いすぎは見苦しい", 'ぁ-ん', '＃', 'cs')
    eq '＃の＃いすぎは＃しい' ? "ok 4\n" : "not ok 4";

print strtr("90 - 32 = 58", "0-9", "A-J")
    eq "JA - DC = FI" ? "ok 5\n" : "not ok 5";

print strtr("90 - 32 = 58", "0-9", "A-J", "R")
    eq "JA - 32 = 58" ? "ok 6\n" : "not ok 6";

print strtr(
    "Caesar Aether Goethe", 
    "aeoeueAeOeUe", 
    "&auml;&ouml;&ouml;&Auml;&Ouml;&Uuml;", 
    "", 
    "[aouAOU]e",
    "&[aouAOU]uml;")
  eq "C&auml;sar &Auml;ther G&ouml;the" ? "ok 7\n" : "not ok 7";

print strtr(
    "Caesar Aether Goethe", 
    [qw/ae oe ue Ae Oe Ue/], 
    [qw/&auml; &ouml; &ouml; &Auml; &Ouml; &Uuml;/]
  )  eq "C&auml;sar &Auml;ther G&ouml;the" ? "ok 8\n" : "not ok 8";

print spaceZ2H('　あ　: 　Ａ＝@＝') eq ' あ :  Ａ＝@＝'
   && spaceH2Z(' 　: 　Ａ＝@＝') eq '　　:　　Ａ＝@＝'
   ? "ok 9\n" : "not ok 9";

$str = 'あいうえおaiueoAIUEOｱｲｳｴｵ日本漢字';
$rev = '字漢本日ｵｴｳｲｱOEUIAoeuiaおえういあ';
print $rev eq ShiftJIS::String::strrev($str)
   ? "ok 10\n" : "not ok 10";

$str = "アイウエオABC-125pQr-xyz";

print "アイウエオ" eq ShiftJIS::String::toupper("アイウエオ")
   ? "ok 11\n" : "not ok 11\n";
print "アイウエオABC-125PQR-XYZ" eq ShiftJIS::String::toupper($str)
   ? "ok 12\n" : "not ok 12\n";
print "アイウエオ" eq ShiftJIS::String::tolower("アイウエオ")
   ? "ok 13\n" : "not ok 13\n";
print "アイウエオabc-125pqr-xyz" eq ShiftJIS::String::tolower($str)
   ? "ok 14\n" : "not ok 14\n";

{
  my $digit_tr = ShiftJIS::String::trclosure(
    "1234567890-",
    "一二三四五六七八九〇－"
  );

  my $frstr1 = "電話：0124-45-6789\n";
  my $tostr1 = "電話：〇一二四－四五－六七八九\n";
  my $frstr2 = "FAX ：0124-51-5368\n";
  my $tostr2 = "FAX ：〇一二四－五一－五三六八\n";

  my $restr1 = &$digit_tr($frstr1);
  my $restr2 = &$digit_tr($frstr2);

  print $tostr1 eq $restr1 ? "ok 15\n" : "not ok 15\n";
  print $tostr2 eq $restr2 ? "ok 16\n" : "not ok 16\n";
}
