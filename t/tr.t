# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..10\n"; }
END {print "not ok 1\n" unless $loaded;}
use ShiftJIS::String qw(strtr spaceH2Z spaceZ2H);

$^W = 1;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.
{
  my($a,$b,$c,$d);

  $a = $b = "abcdefg-123456789";
  $c = ShiftJIS::String::strtr(\$a,'a-cd','15-7','R');
  $d = $b =~ tr'a-cd'15-7';
  print $a eq $b && $c == $d ? "ok 2\n" : "not ok 2\n";

  my @uc = ("", "I", "IA", "AIS", "ASIB","AAA");
  my @lc = ("", "i", "ia", "ais", "asib","aba");
  my @mod = ("", "d", "c", "cd", "s", "sd", "sc", "scd");
  my $str = "THIS IS A PEN. YOU ARE A RABBIT.";
  my($i, $j, $m, $core, $sjis, $ccnt, $scnt);

  for $m(0..$#mod){
    $NG = 0;
    for $i(0..$#uc){
      for $j(0..$#lc){
        $sjis = $core = $str;
        $ccnt = eval "\$core =~ tr/$uc[$i]/$lc[$j]/$mod[$m];";
        $scnt = ShiftJIS::String::strtr(\$sjis, $uc[$i], $lc[$j], $mod[$m]);
        ++$NG unless $core eq $sjis && $ccnt == $scnt;
      }
    }
    print ! $NG ? "ok" : "not ok", " ", $m+3, "\n";
  }
}
