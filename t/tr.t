# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

BEGIN { $| = 1; print "1..10\n"; }
END {print "not ok 1\n" unless $loaded;}

use ShiftJIS::String qw(strtr);

$^W = 1;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.
{
  my($a,$b,$c,$d);

  $a = $b = "abcdefg-123456789";
  $c = strtr(\$a,'a-cd','15-7','R');
  $d = $b =~ tr'a-cd'15-7';
  print $a eq $b && $c == $d ? "ok" : "not ok", " ", ++$loaded, "\n";

  my @mod = ("", "d", "c", "cd", "s", "sd", "sc", "scd");
  my @uc = ("", "I", "IA", "AIS", "ASIB","AAA");
  my @lc = ("", "i", "ia", "ais", "asib","aba");
  my $str = "THIS IS A PEN. YOU ARE A RABBIT.";
  my($i, $j, $m, $core, $sjis, $nstr, $ccnt, $scnt, $ncnt);

  for $m (@mod){
    $NG = 0;
    for $i (0..$#uc) {
      for $j (0..$#lc) {
        $nstr = $sjis = $core = $str;
        $ccnt = eval "\$core =~ tr/$uc[$i]/$lc[$j]/$m;";
        $scnt = strtr(\$sjis, $uc[$i], $lc[$j], $m);
        $ncnt = strtr(\$nstr, $uc[$i], $lc[$j], "n$m");
        ++$NG unless $core eq $sjis && $ccnt == $scnt
                  && $core eq $nstr && $ccnt == $ncnt;
      }
    }
    print ! $NG ? "ok" : "not ok", " ", ++$loaded, "\n";
  }
}
