# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

BEGIN { $| = 1; print "1..19\n"; }
END {print "not ok 1\n" unless $loaded;}

use ShiftJIS::String qw(:kana :H2Z :Z2H toupper tolower);

$^W = 1;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

{
my $kataH
 = '｡｢｣､･ｦｧｨｩｪｫｬｭｮｯｰｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝﾞﾟ'
 . 'ｶﾞｷﾞｸﾞｹﾞｺﾞｻﾞｼﾞｽﾞｾﾞｿﾞﾀﾞﾁﾞﾂﾞﾃﾞﾄﾞﾊﾞﾋﾞﾌﾞﾍﾞﾎﾞﾊﾟﾋﾟﾌﾟﾍﾟﾎﾟｳﾞ';

my $kataZ
 = '。「」、・ヲァィゥェォャュョッーアイウエオカキクケコサシスセソタ'
 . 'チツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワン゛゜'
 . 'ガギグゲゴザジズゼゾダヂヅデドバビブベボパピプペポヴ';

my $hiraZ
 = '。「」、・をぁぃぅぇぉゃゅょっーあいうえおかきくけこさしすせそた'
 . 'ちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわん゛゜'
 . 'がぎぐげござじずぜぞだぢづでどばびぶべぼぱぴぷぺぽう゛';

my $hiraZK
 = '｡｢｣､･をぁぃぅぇぉゃゅょっｰあいうえおかきくけこさしすせそた'
 . 'ちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわんﾞﾟ'
 . 'がぎぐげござじずぜぞだぢづでどばびぶべぼぱぴぷぺぽう゛';

my $all = $hiraZ.$kataZ.$kataH;

# ゐゑゎヮヶなどはテストから除外。

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

print hiXka('ゐゑゎかけアヴヰヱヮヵヶウ') eq 'ヰヱヮカケあう゛ゐゑゎかけう'
   && ka2hi('ゐゑゎかけアヴヰヱヮヵヶウ') eq 'ゐゑゎかけあう゛ゐゑゎかけう'
   && hi2ka('ゐゑゎかけアヴヰヱヮヵヶウ') eq 'ヰヱヮカケアヴヰヱヮヵヶウ'
    ? "ok" : "not ok", " ", ++$loaded, "\n";

{
  my $lo = 'abcdefghijklmnopqrstuvwxyz';
  my $up = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  my $sp = ' ';
  my $zp = '　';
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
    [ qw/ こんちには こんちには   0 / ],
    [ qw/ ｺﾝﾆﾁﾊ      コンニチハ   5 / ],
    [ qw/ ﾊﾟｰﾙ       パール       3 / ],
    [ qw/ ﾌﾟﾛｸﾞﾗﾑ言語 プログラム言語 5 / ],
    [ qw/ ﾋﾞﾀﾞｸｵﾝ    ビダクオン   5 / ],
    [ qw/ ｶﾟｷﾟｸﾟｹﾟｺﾟ カ゜キ゜ク゜ケ゜コ゜ 10 / ],
    [ qw/ えﾞ｡       え゛。       2 / ],
    [ qw/ ｴﾞ｡        エ゛。       3 / ],
    [ qw/ Aｳﾞ｡B      Aヴ。B       2 / ],
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
    [ qw/ あいうえABCDこんちには あいうえabcdこんちには   4 / ],
    [ qw/ アルファベットを含まない  アルファベットを含まない 0 / ],
    [ qw/ Perl_Module    perl_module   2 / ],
    [ qw/ Ｐｅｒｌを使う Ｐｅｒｌを使う 0 / ],
  ) {
    my $str = $ary->[0];
    $ng++ unless tolower($str)  eq $ary->[1];
    $ng++ unless $str eq $ary->[0];
    $ng++ unless tolower(\$str) eq $ary->[2];
    $ng++ unless $str eq $ary->[1];
  }
  print $ng == 0 ? "ok" : "not ok", " ", ++$loaded, "\n";
}


