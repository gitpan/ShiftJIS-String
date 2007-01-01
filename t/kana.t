
BEGIN { $| = 1; print "1..367\n"; }
END {print "not ok 1\n" unless $loaded;}

use ShiftJIS::String qw(:kana :H2Z :Z2H toupper tolower);

$^W = 1;
$loaded = 1;
print "ok 1\n";

#####

{
  $kataH
  = 'ｦｧｨｩｪｫｬｭｮｯｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝ'
  . 'ｶﾞｷﾞｸﾞｹﾞｺﾞｻﾞｼﾞｽﾞｾﾞｿﾞﾀﾞﾁﾞﾂﾞﾃﾞﾄﾞﾊﾞﾋﾞﾌﾞﾍﾞﾎﾞﾊﾟﾋﾟﾌﾟﾍﾟﾎﾟｳﾞ';

  $kataZ
  = 'ヲァィゥェォャュョッアイウエオカキクケコサシスセソタ'
  . 'チツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワン'
  . 'ガギグゲゴザジズゼゾダヂヅデドバビブベボパピプペポヴ';

  $hiraZ
  = 'をぁぃぅぇぉゃゅょっあいうえおかきくけこさしすせそた'
  . 'ちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわん'
  . 'がぎぐげござじずぜぞだぢづでどばびぶべぼぱぴぷぺぽう゛';

  $all = $hiraZ.$kataZ.$kataH;

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


{
  $kigouH = '｡｢｣､･ｰﾞﾟ';
  $kigouZ = '。「」、・ー゛゜';
  $kigouA = $kigouZ.$kigouH;

  foreach $ary (
    [ \&kataH2Z,  $kigouZ.$kigouZ,  8 ],
    [ \&kanaH2Z,  $kigouZ.$kigouZ,  8 ],
    [ \&hiraH2Z,  $kigouZ.$kigouZ,  8 ],
    [ \&kataZ2H,  $kigouH.$kigouH,  8 ],
    [ \&kanaZ2H,  $kigouH.$kigouH,  8 ],
    [ \&hiraZ2H,  $kigouH.$kigouH,  8 ],
    [ \&hiXka,    $kigouZ.$kigouH,  0 ],
    [ \&hi2ka,    $kigouZ.$kigouH,  0 ],
    [ \&ka2hi,    $kigouZ.$kigouH,  0 ],
    [ \&spaceH2Z, $kigouZ.$kigouH,  0 ],
    [ \&spaceZ2H, $kigouZ.$kigouH,  0 ],
    [ \&toupper,  $kigouZ.$kigouH,  0 ],
    [ \&tolower,  $kigouZ.$kigouH,  0 ],
  ) {
    $str = $kigouA;
    print &{ $ary->[0] }($str) eq $ary->[1]
	? "ok" : "not ok", " ", ++$loaded, "\n";
    print $str eq $kigouA
	? "ok" : "not ok", " ", ++$loaded, "\n";
    print &{ $ary->[0] }(\$str) eq $ary->[2]
	? "ok" : "not ok", " ", ++$loaded, "\n";
    print $str eq $ary->[1]
	? "ok" : "not ok", " ", ++$loaded, "\n";
  }
}


{
  my $wiwewakake = 'ゐゑゎかけアヴヰヱヮヵヶウゝゞヽヾ';

  foreach $ary (
    [ \&kataH2Z,  'ゐゑゎかけアヴヰヱヮヵヶウゝゞヽヾ',    0 ],
    [ \&kanaH2Z,  'ゐゑゎかけアヴヰヱヮヵヶウゝゞヽヾ',    0 ],
    [ \&hiraH2Z,  'ゐゑゎかけアヴヰヱヮヵヶウゝゞヽヾ',    0 ],
    [ \&kataZ2H,  'ゐゑゎかけｱｳﾞｲｴﾜｶｹｳゝゞヽヾ',           8 ],
    [ \&kanaZ2H,  'ｲｴﾜｶｹｱｳﾞｲｴﾜｶｹｳゝゞヽヾ',               13 ],
    [ \&hiraZ2H,  'ｲｴﾜｶｹアヴヰヱヮヵヶウゝゞヽヾ',         5 ],
    [ \&hiXka,    'ヰヱヮカケあう゛ゐゑゎかけうヽヾゝゞ', 17 ],
    [ \&hi2ka,    'ヰヱヮカケアヴヰヱヮヵヶウヽヾヽヾ',    7 ],
    [ \&ka2hi,    'ゐゑゎかけあう゛ゐゑゎかけうゝゞゝゞ', 10 ],
    [ \&spaceH2Z, 'ゐゑゎかけアヴヰヱヮヵヶウゝゞヽヾ',    0 ],
    [ \&spaceZ2H, 'ゐゑゎかけアヴヰヱヮヵヶウゝゞヽヾ',    0 ],
    [ \&toupper,  'ゐゑゎかけアヴヰヱヮヵヶウゝゞヽヾ',    0 ],
    [ \&tolower,  'ゐゑゎかけアヴヰヱヮヵヶウゝゞヽヾ',    0 ],
  ) {
    $str = $wiwewakake;
    print &{ $ary->[0] }($str) eq $ary->[1]
	? "ok" : "not ok", " ", ++$loaded, "\n";
    print $str eq $wiwewakake
	? "ok" : "not ok", " ", ++$loaded, "\n";
    print &{ $ary->[0] }(\$str) eq $ary->[2]
	? "ok" : "not ok", " ", ++$loaded, "\n";
    print $str eq $ary->[1]
	? "ok" : "not ok", " ", ++$loaded, "\n";
  }
}


{
  $kanaV = 'ｳﾞｧｳﾞｨｳﾞｳﾞｪｳﾞｫｳﾞｬｳﾞｭｳﾞｮ';
  $kataV = 'ヴァヴィヴヴェヴォヴャヴュヴョ';
  $hiraV = 'う゛ぁう゛ぃう゛う゛ぇう゛ぉう゛ゃう゛ゅう゛ょ';

  $allV = $hiraV.$kataV.$kanaV;

  foreach $ary (
    [ \&kataH2Z,  $hiraV.$kataV.$kataV,  15 ],
    [ \&kanaH2Z,  $hiraV.$kataV.$kataV,  15 ],
    [ \&hiraH2Z,  $hiraV.$kataV.$hiraV,  15 ],
    [ \&kataZ2H,  $hiraV.$kanaV.$kanaV,  15 ],
    [ \&kanaZ2H,  $kanaV.$kanaV.$kanaV,  30 ],
    [ \&hiraZ2H,  $kanaV.$kataV.$kanaV,  15 ],
    [ \&hiXka,    $kataV.$hiraV.$kanaV,  30 ],
    [ \&hi2ka,    $kataV.$kataV.$kanaV,  15 ],
    [ \&ka2hi,    $hiraV.$hiraV.$kanaV,  15 ],
    [ \&spaceH2Z, $hiraV.$kataV.$kanaV,   0 ],
    [ \&spaceZ2H, $hiraV.$kataV.$kanaV,   0 ],
    [ \&toupper,  $hiraV.$kataV.$kanaV,   0 ],
    [ \&tolower,  $hiraV.$kataV.$kanaV,   0 ],
  ) {
    $str = $allV;
    print &{ $ary->[0] }($str) eq $ary->[1]
	? "ok" : "not ok", " ", ++$loaded, "\n";
    print $str eq $allV
	? "ok" : "not ok", " ", ++$loaded, "\n";
    print &{ $ary->[0] }(\$str) eq $ary->[2]
	? "ok" : "not ok", " ", ++$loaded, "\n";
    print $str eq $ary->[1]
	? "ok" : "not ok", " ", ++$loaded, "\n";
  }
}

{
  $lo = 'abcdefghijklmnopqrstuvwxyz';
  $up = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  $sp = ' ';
  $zp = '　';
  $allSUL = "$sp$lo$zp$up$sp$lo";

  foreach $ary (
    [ \&kataH2Z,  "$sp$lo$zp$up$sp$lo",  0 ],
    [ \&kanaH2Z,  "$sp$lo$zp$up$sp$lo",  0 ],
    [ \&hiraH2Z,  "$sp$lo$zp$up$sp$lo",  0 ],
    [ \&kataZ2H,  "$sp$lo$zp$up$sp$lo",  0 ],
    [ \&kanaZ2H,  "$sp$lo$zp$up$sp$lo",  0 ],
    [ \&hiraZ2H,  "$sp$lo$zp$up$sp$lo",  0 ],
    [ \&hiXka,    "$sp$lo$zp$up$sp$lo",  0 ],
    [ \&hi2ka,    "$sp$lo$zp$up$sp$lo",  0 ],
    [ \&ka2hi,    "$sp$lo$zp$up$sp$lo",  0 ],
    [ \&toupper,  "$sp$up$zp$up$sp$up", 52 ],
    [ \&tolower,  "$sp$lo$zp$lo$sp$lo", 26 ],
    [ \&spaceH2Z, "$zp$lo$zp$up$zp$lo",  2 ],
    [ \&spaceZ2H, "$sp$lo$sp$up$sp$lo",  1 ],
  ) {
    $str = $allSUL;
    print &{ $ary->[0] }($str) eq $ary->[1]
	? "ok" : "not ok", " ", ++$loaded, "\n";
    print $str eq $allSUL
	? "ok" : "not ok", " ", ++$loaded, "\n";
    print &{ $ary->[0] }(\$str) eq $ary->[2]
	? "ok" : "not ok", " ", ++$loaded, "\n";
    print $str eq $ary->[1]
	? "ok" : "not ok", " ", ++$loaded, "\n";
  }
}


{
  for $ary (
    [ \&kanaZ2H, qw/ ウ゛ァウ゛ィウ゛ウ゛ェウ゛ォ   ｳﾞｧｳﾞｨｳﾞｳﾞｪｳﾞｫ  14 / ],
    [ \&kataZ2H, qw/ ウ゛ァウ゛ィウ゛ウ゛ェウ゛ォ   ｳﾞｧｳﾞｨｳﾞｳﾞｪｳﾞｫ  14 / ],
    [ \&hiraZ2H, 'ウ゛ァウ゛ィウ゛ウ゛ェウ゛ォ',
                 'ウﾞァウﾞィウﾞウﾞェウﾞォ',  5],
    [ \&kanaZ2H, qw/ う゛ぁう゛ぃう゛う゛ぇう゛ぉ   ｳﾞｧｳﾞｨｳﾞｳﾞｪｳﾞｫ   9 / ],
    [ \&hiraZ2H, qw/ う゛ぁう゛ぃう゛う゛ぇう゛ぉ   ｳﾞｧｳﾞｨｳﾞｳﾞｪｳﾞｫ   9 / ],
    [ \&kataZ2H, 'う゛ぁう゛ぃう゛う゛ぇう゛ぉ',
                 'う゛ぁう゛ぃう゛う゛ぇう゛ぉ',  0 ],
    [ \&kanaH2Z, qw/ こんちには こんちには   0 / ],
    [ \&kanaH2Z, qw/ ｺﾝﾆﾁﾊ      コンニチハ   5 / ],
    [ \&kanaH2Z, qw/ ﾊﾟｰﾙ       パール       3 / ],
    [ \&kanaH2Z, qw/ ﾌﾟﾛｸﾞﾗﾑ言語 プログラム言語 5 / ],
    [ \&kanaH2Z, qw/ ﾋﾞﾀﾞｸｵﾝ    ビダクオン   5 / ],
    [ \&kanaH2Z, qw/ ｶﾟｷﾟｸﾟｹﾟｺﾟ カ゜キ゜ク゜ケ゜コ゜ 10 / ],
    [ \&kanaH2Z, qw/ えﾞ｡       え゛。       2 / ],
    [ \&kanaH2Z, qw/ ｴﾞ｡        エ゛。       3 / ],
    [ \&kanaH2Z, qw/ Aｳﾞ｡B      Aヴ。B       2 / ],
    [ \&kataH2Z, qw/ こんちには こんちには   0 / ],
    [ \&kataH2Z, qw/ ｺﾝﾆﾁﾊ      コンニチハ   5 / ],
    [ \&kataH2Z, qw/ ﾊﾟｰﾙ       パール       3 / ],
    [ \&hiraH2Z, qw/ こんちには こんちには   0 / ],
    [ \&hiraH2Z, qw/ ｺﾝﾆﾁﾊ      こんにちは   5 / ],
    [ \&hiraH2Z, qw/ ﾊﾟｰﾙ       ぱーる       3 / ],
    [ \&tolower, qw/ あいうえABCDこんちには あいうえabcdこんちには   4 / ],
    [ \&tolower, qw/ アルファベットを含まない  アルファベットを含まない 0 / ],
    [ \&tolower, qw/ Perl_Module    perl_module   2 / ],
    [ \&tolower, qw/ Ｐｅｒｌを使う Ｐｅｒｌを使う 0 / ],
  ) {
    $str = $ary->[1];
    print &{ $ary->[0] }($str)  eq $ary->[2]
	? "ok" : "not ok", " ", ++$loaded, "\n";
    print $str eq $ary->[1]
	? "ok" : "not ok", " ", ++$loaded, "\n";
    print &{ $ary->[0] }(\$str) eq $ary->[3]
	? "ok" : "not ok", " ", ++$loaded, "\n";
    print $str eq $ary->[2]
	? "ok" : "not ok", " ", ++$loaded, "\n";
  }
}

sub stricmp { toupper($_[0]) cmp toupper($_[1]) }

print  0 == stricmp('', '')
  ? "ok" : "not ok", " ", ++$loaded, "\n";
print -1 == stricmp('', "\0")
  ? "ok" : "not ok", " ", ++$loaded, "\n";
print  0 == stricmp('A', 'a')
  ? "ok" : "not ok", " ", ++$loaded, "\n";
print -1 == stricmp('講習', '講縮')
  ? "ok" : "not ok", " ", ++$loaded, "\n";
print  0 == stricmp('プログラミングPerl',  'プログラミングPERL')
  ? "ok" : "not ok", " ", ++$loaded, "\n";
print -1 == stricmp('プログラミングPerl',  'プログラミンバPERL')
  ? "ok" : "not ok", " ", ++$loaded, "\n";

1;
__END__
