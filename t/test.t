# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

BEGIN { $| = 1; print "1..18\n"; }
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

print strtr("90 - 32 = 58", "0-9", "A-J") eq "JA - DC = FI"
   && strtr("90 - 32 = 58", "0-9", "A-J", "R") eq "JA - 32 = 58"
    ? "ok" : "not ok", " 5\n";

print strtr("A\0BC\0\0", "A\0C\0", "XY\0K") eq "XYB\0YY"
   && strtr("\0\0\0AA", "\0", "", "cd") eq "\0\0\0"
   && strtr("\0\0V\0AA", "\0", "", "d") eq "VAA"
 ? "ok" : "not ok", " 6\n";

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

print strrev($str) eq '字漢本日ｵｴｳｲｱOEUIAoeuiaおえういあ'
   && strrev("")   eq ""
   && strrev(0)    eq  0
   && strrev(1)    eq  1
   && strrev("1")  eq "1"
   && strrev("あ") eq "あ"
   && strrev("いあ") eq "あい"
   && strrev("Aあ")  eq "あA"
   && strrev("あA")  eq "Aあ"
   && strrev("逆A-\0!\0") eq "\0!\0-A逆"
   ? "ok" : "not ok", " 10\n";

$str = "0123アイウエオｱｲｳｴｵ";

print $str eq toupper($str)
   && $str eq tolower($str)
   ? "ok" : "not ok", " 11\n";

$str = "アイウエオABC-125pQr-xyz";
print "アイウエオABC-125PQR-XYZ" eq toupper($str)
   && "アイウエオabc-125pqr-xyz" eq tolower($str)
   ? "ok" : "not ok", " 12\n";

print 1
  && toupper("")  eq ""
  && tolower("")  eq ""
  && toupper(0)   eq  0
  && tolower(0)   eq  0
  && toupper(12)  eq 12
  && tolower(12)  eq 12
  && toupper(-41) eq -41
  && tolower(-41) eq -41
  ? "ok" : "not ok", " 13\n";

print 1
  && hi2ka("")   eq ""
  && ka2hi("")   eq ""
  && hiXka("")   eq ""
  && kanaH2Z("") eq ""
  && kataH2Z("") eq ""
  && spaceH2Z("") eq ""
  && kanaZ2H("") eq ""
  && kataZ2H("") eq ""
  && spaceZ2H("") eq ""
  && hi2ka(0)   eq 0
  && ka2hi(0)   eq 0
  && hiXka(0)   eq 0
  && kanaH2Z(0) eq 0
  && kataH2Z(0) eq 0
  && spaceH2Z(0) eq 0
  && kanaZ2H(0) eq 0
  && kataZ2H(0) eq 0
  && spaceZ2H(0) eq 0
  && hi2ka(1)   eq 1
  && ka2hi(1)   eq 1
  && hiXka(1)   eq 1
  && kanaH2Z(1) eq 1
  && kataH2Z(1) eq 1
  && spaceH2Z(1) eq 1
  && kanaZ2H(1) eq 1
  && kataZ2H(1) eq 1
  && spaceZ2H(1) eq 1
  ? "ok" : "not ok", " 14\n";

{
  my $digit_tr = trclosure(
    "1234567890-",
    "一二三四五六七八九〇−"
  );

  my $frstr1 = "電話：0124-45-6789\n";
  my $tostr1 = "電話：〇一二四−四五−六七八九\n";
  my $frstr2 = "FAX ：0124-51-5368\n";
  my $tostr2 = "FAX ：〇一二四−五一−五三六八\n";

  my $restr1 = &$digit_tr($frstr1);
  my $restr2 = &$digit_tr($frstr2);

  print $tostr1 eq $restr1 ? "ok" : "not ok", " 15\n";
  print $tostr2 eq $restr2 ? "ok" : "not ok", " 16\n";
}

$str = 'プログラミング Perl';
$len = length(substr($str, 2 + index($str, 'ラミ')));
print $len == 7 ? "ok" : "not ok", " 17\n";

print strspn("XZ\0Z\0Y", "\0X\0YZ") == 6
  &&  strcspn("Perlは面白い。", "XY\0r") == 2
  &&  strspn("+0.12345*12", "+-.0123456789") == 8
  &&  strcspn("Perlは面白い。", "赤青黄白黒") == 6
  &&  strspn("", "123") == 0
  &&  strcspn("", "123") == 0
  &&  strspn("あいうえお", "") == 0
  &&  strcspn("あいうえお", "") == 5
 ? "ok" : "not ok", " 18\n";

