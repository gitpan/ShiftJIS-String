# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..8\n"; }
END {print "not ok 1\n" unless $loaded;}
use ShiftJIS::String qw(strtr spaceH2Z spaceZ2H);

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

  print ShiftJIS::String::kataH2Z($all) eq $hiraZ.$kataZ.$kataZ
    ? "ok" : "not ok", " 2\n";
  print ShiftJIS::String::kanaH2Z($all) eq $hiraZ.$kataZ.$kataZ
    ? "ok" : "not ok", " 3\n";
  print ShiftJIS::String::kataZ2H($all) eq $hiraZK.$kataH.$kataH
    ? "ok" : "not ok", " 4\n";
  print ShiftJIS::String::kanaZ2H($all) eq $kataH.$kataH.$kataH
    ? "ok" : "not ok", " 5\n";
  print ShiftJIS::String::hiXka($all) eq $kataZ.$hiraZ.$kataH
    ? "ok" : "not ok", " 6\n";
  print ShiftJIS::String::hi2ka($all) eq $kataZ.$kataZ.$kataH
    ? "ok" : "not ok", " 7\n";
  print ShiftJIS::String::ka2hi($all) eq $hiraZ.$hiraZ.$kataH
    ? "ok" : "not ok", " 8\n";
}
