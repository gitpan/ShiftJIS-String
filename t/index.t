# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..57\n"; }
END {print "not ok 1\n" unless $loaded;}
use ShiftJIS::String qw(strtr spaceH2Z spaceZ2H);
$^W = 1;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

{
  my $str = '+0.1231425126-*12346';
  my $zen = 'Å{ÇOÅDÇPÇQ3ÇPÇSÇQÇTÇPÇQ6-ÅñÇPÇQÇR4ÇU';
  my $sub = '12';
  my $sbz = 'ÇPÇQ';
  my($pos,$si, $bi);

  my $n = 1;

  for $pos (-10..18){
    $si = index($str,$sub,$pos);
    $bi = ShiftJIS::String::index($zen,$sbz,$pos);
    print $si == $bi ? "ok" : "not ok", " ", ++$n, "\n";
  }

  for $pos (-10..16){
    $si = rindex($str,$sub,$pos);
    $bi = ShiftJIS::String::rindex($zen,$sbz,$pos);
    print $si == $bi ? "ok" : "not ok", " ", ++$n, "\n";
  }
}
