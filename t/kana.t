
BEGIN { $| = 1; print "1..367\n"; }
END {print "not ok 1\n" unless $loaded;}

use ShiftJIS::String qw(:kana :H2Z :Z2H toupper tolower);

$^W = 1;
$loaded = 1;
print "ok 1\n";

#####

{
  $kataH
  = '¦§¨©ª«¬­®¯±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝ'
  . '¶Þ·Þ¸Þ¹ÞºÞ»Þ¼Þ½Þ¾Þ¿ÞÀÞÁÞÂÞÃÞÄÞÊÞËÞÌÞÍÞÎÞÊßËßÌßÍßÎß³Þ';

  $kataZ
  = '@BDFHbACEGIJLNPRTVXZ\^'
  . '`cegijklmnqtwz}~'
  . 'KMOQSUWY[]_adfhorux{psvy|';

  $hiraZ
  = 'ð¡£¥§áãåÁ ¢¤¦¨©«­¯±³µ·¹»½'
  . '¿ÂÄÆÈÉÊËÌÍÐÓÖÙÜÝÞßàâäæçèéêëíñ'
  . 'ª¬®°²´¶¸º¼¾ÀÃÅÇÎÑÔ×ÚÏÒÕØÛ¤J';

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
  $kigouH = '¡¢£¤¥°Þß';
  $kigouZ = 'BuvAE[JK';
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
  my $wiwewakake = 'îïì©¯AETURS';

  foreach $ary (
    [ \&kataH2Z,  'îïì©¯AETURS',    0 ],
    [ \&kanaH2Z,  'îïì©¯AETURS',    0 ],
    [ \&hiraH2Z,  'îïì©¯AETURS',    0 ],
    [ \&kataZ2H,  'îïì©¯±³Þ²´Ü¶¹³TURS',           8 ],
    [ \&kanaZ2H,  '²´Ü¶¹±³Þ²´Ü¶¹³TURS',               13 ],
    [ \&hiraZ2H,  '²´Ü¶¹AETURS',         5 ],
    [ \&hiXka,    'JP ¤Jîïì©¯¤RSTU', 17 ],
    [ \&hi2ka,    'JPAERSRS',    7 ],
    [ \&ka2hi,    'îïì©¯ ¤Jîïì©¯¤TUTU', 10 ],
    [ \&spaceH2Z, 'îïì©¯AETURS',    0 ],
    [ \&spaceZ2H, 'îïì©¯AETURS',    0 ],
    [ \&toupper,  'îïì©¯AETURS',    0 ],
    [ \&tolower,  'îïì©¯AETURS',    0 ],
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
  $kanaV = '³Þ§³Þ¨³Þ³Þª³Þ«³Þ¬³Þ­³Þ®';
  $kataV = '@BFH';
  $hiraV = '¤J¤J¡¤J¤J¥¤J§¤Já¤Jã¤Jå';

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
  $zp = '@';
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
    [ \&kanaZ2H, qw/ EJ@EJBEJEJFEJH   ³Þ§³Þ¨³Þ³Þª³Þ«  14 / ],
    [ \&kataZ2H, qw/ EJ@EJBEJEJFEJH   ³Þ§³Þ¨³Þ³Þª³Þ«  14 / ],
    [ \&hiraZ2H, 'EJ@EJBEJEJFEJH',
                 'EÞ@EÞBEÞEÞFEÞH',  5],
    [ \&kanaZ2H, qw/ ¤J¤J¡¤J¤J¥¤J§   ³Þ§³Þ¨³Þ³Þª³Þ«   9 / ],
    [ \&hiraZ2H, qw/ ¤J¤J¡¤J¤J¥¤J§   ³Þ§³Þ¨³Þ³Þª³Þ«   9 / ],
    [ \&kataZ2H, '¤J¤J¡¤J¤J¥¤J§',
                 '¤J¤J¡¤J¤J¥¤J§',  0 ],
    [ \&kanaH2Z, qw/ ±ñ¿ÉÍ ±ñ¿ÉÍ   0 / ],
    [ \&kanaH2Z, qw/ ºÝÆÁÊ      Rj`n   5 / ],
    [ \&kanaH2Z, qw/ Êß°Ù       p[       3 / ],
    [ \&kanaH2Z, qw/ ÌßÛ¸Þ×Ñ¾ê vO¾ê 5 / ],
    [ \&kanaH2Z, qw/ ËÞÀÞ¸µÝ    r_NI   5 / ],
    [ \&kanaH2Z, qw/ ¶ß·ß¸ß¹ßºß JKLKNKPKRK 10 / ],
    [ \&kanaH2Z, qw/ ¦Þ¡       ¦JB       2 / ],
    [ \&kanaH2Z, qw/ ´Þ¡        GJB       3 / ],
    [ \&kanaH2Z, qw/ A³Þ¡B      ABB       2 / ],
    [ \&kataH2Z, qw/ ±ñ¿ÉÍ ±ñ¿ÉÍ   0 / ],
    [ \&kataH2Z, qw/ ºÝÆÁÊ      Rj`n   5 / ],
    [ \&kataH2Z, qw/ Êß°Ù       p[       3 / ],
    [ \&hiraH2Z, qw/ ±ñ¿ÉÍ ±ñ¿ÉÍ   0 / ],
    [ \&hiraH2Z, qw/ ºÝÆÁÊ      ±ñÉ¿Í   5 / ],
    [ \&hiraH2Z, qw/ Êß°Ù       Ï[é       3 / ],
    [ \&tolower, qw/  ¢¤¦ABCD±ñ¿ÉÍ  ¢¤¦abcd±ñ¿ÉÍ   4 / ],
    [ \&tolower, qw/ At@xbgðÜÜÈ¢  At@xbgðÜÜÈ¢ 0 / ],
    [ \&tolower, qw/ Perl_Module    perl_module   2 / ],
    [ \&tolower, qw/ oðg¤ oðg¤ 0 / ],
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
print -1 == stricmp('uK', 'uk')
  ? "ok" : "not ok", " ", ++$loaded, "\n";
print  0 == stricmp('vO~OPerl',  'vO~OPERL')
  ? "ok" : "not ok", " ", ++$loaded, "\n";
print -1 == stricmp('vO~OPerl',  'vO~oPERL')
  ? "ok" : "not ok", " ", ++$loaded, "\n";

1;
__END__
