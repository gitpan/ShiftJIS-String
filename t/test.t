# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

BEGIN { $| = 1; print "1..17\n"; }
END {print "not ok 1\n" unless $loaded;}

use ShiftJIS::String qw(:all);

$^W = 1;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

$str = "なんといおうか";
print strtr(\$str,"あいうえお", "アイウエオ") . "  " . $str
    eq "3  なんとイオウか" ? "ok" : "not ok", " 2\n";

print strtr('おかかうめぼし　ちちとはは', 'ぁ-ん', '', 's')
    eq 'おかうめぼし　ちとは'  ? "ok" : "not ok", " 3\n";

print strtr("条件演算子の使いすぎは見苦しい", 'ぁ-ん', '＃', 'cs')
    eq '＃の＃いすぎは＃しい' ? "ok" : "not ok", " 4\n";

print strtr("90 - 32 = 58", "0-9", "A-J")
    eq "JA - DC = FI" ? "ok" : "not ok", " 5\n";

print strtr("90 - 32 = 58", "0-9", "A-J", "R")
    eq "JA - 32 = 58" ? "ok" : "not ok", " 6\n";

print strtr(
    "Caesar Aether Goethe", 
    "aeoeueAeOeUe", 
    "&auml;&ouml;&ouml;&Auml;&Ouml;&Uuml;", 
    "", 
    "[aouAOU]e",
    "&[aouAOU]uml;")
  eq "C&auml;sar &Auml;ther G&ouml;the" ? "ok" : "not ok", " 7\n";

print strtr(
    "Caesar Aether Goethe", 
    [qw/ae oe ue Ae Oe Ue/], 
    [qw/&auml; &ouml; &ouml; &Auml; &Ouml; &Uuml;/]
  )  eq "C&auml;sar &Auml;ther G&ouml;the" ? "ok" : "not ok", " 8\n";

print spaceZ2H('　あ　: 　Ａ＝@＝') eq ' あ :  Ａ＝@＝'
   && spaceH2Z(' 　: 　Ａ＝@＝') eq '　　:　　Ａ＝@＝'
   ? "ok" : "not ok", " 9\n";

$str = 'あいうえおaiueoAIUEOｱｲｳｴｵ日本漢字';
$rev = '字漢本日ｵｴｳｲｱOEUIAoeuiaおえういあ';
print $rev eq strrev($str)
   ? "ok" : "not ok", " 10\n";

$str = "アイウエオABC-125pQr-xyz";

print "アイウエオ" eq toupper("アイウエオ")
   ? "ok" : "not ok", " 11\n";
print "アイウエオABC-125PQR-XYZ" eq toupper($str)
   ? "ok" : "not ok", " 12\n";
print "アイウエオ" eq tolower("アイウエオ")
   ? "ok" : "not ok", " 13\n";
print "アイウエオabc-125pqr-xyz" eq tolower($str)
   ? "ok" : "not ok", " 14\n";

{
  my $digit_tr = trclosure(
    "1234567890-",
    "一二三四五六七八九〇－"
  );

  my $frstr1 = "電話：0124-45-6789\n";
  my $tostr1 = "電話：〇一二四－四五－六七八九\n";
  my $frstr2 = "FAX ：0124-51-5368\n";
  my $tostr2 = "FAX ：〇一二四－五一－五三六八\n";

  my $restr1 = &$digit_tr($frstr1);
  my $restr2 = &$digit_tr($frstr2);

  print $tostr1 eq $restr1 ? "ok" : "not ok", " 15\n";
  print $tostr2 eq $restr2 ? "ok" : "not ok", " 16\n";
}

$str = 'プログラミング Perl';
$len = length(substr($str, 2 + index($str, 'ラミ')));
print $len == 7 ? "ok" : "not ok", " 17\n";
