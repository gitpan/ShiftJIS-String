
BEGIN { $| = 1; print "1..16\n"; }
END {print "not ok 1\n" unless $loaded;}

use ShiftJIS::String qw(issjis);
$^W = 1;
$loaded = 1;
print "ok 1\n";

#####

{
  $n = 1;
  for (
	"漢字テスト",
	"abc",
	"ｱｲｳｴｵ",
	"ﾊﾟｰﾙ=Perl",
	"\001\002\003\000\n",
	"",
	" ",
	'　',
  ){
     print issjis($_) ? "ok" : "not ok", " ", ++$n, "\n";
  }
  for (
	"それもそうだ\x8080",
	"どうにもこうにも\x81\x39",
	"\x91\x00",
	"\xaf\xe2",
	"これは\xFFどうかな",
  ){
     print ! issjis($_) ? "ok" : "not ok", " ", ++$n, "\n";
  }
  print  issjis("あ", "P", "", "ｶﾝｼﾞ test") ? "ok" : "not ok", " ", ++$n, "\n";
  print !issjis("日本","さkanji","\xA0") ? "ok" : "not ok", " ", ++$n, "\n";
}

1;
__END__
