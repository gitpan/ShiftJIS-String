# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..6\n"; }
END {print "not ok 1\n" unless $loaded;}
use ShiftJIS::String qw(strtr spaceH2Z spaceZ2H);

$^W = 1;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.
{
  my $printZ2H = ShiftJIS::String::trclosure(
    '‚O-‚X‚`-‚y‚-‚š@{|HI”“•—–ƒ„ijmnop',
    '0-9A-Za-z =+\-?!#$%&@*<>()[]{}',
  );
  my $NG;
  my $str = '01234567';
  my $zen = '0‚P‚Q‚R456‚V';
  my($i,$j);

  $NG = 0;
  for $i (-10..10){
    local $^W = 0;
    my $s = substr($str,$i);
    my $t = ShiftJIS::String::substr($zen,$i);
    for($s,$t){$_ = 'undef' if ! defined $_;}
    ++$NG unless $s eq $printZ2H->($t);
  }
  print ! $NG ? "ok 2\n" : "not ok 2\n";

  $NG = 0;
  for $i (-10..10){
    for $j (undef,-10..10){
      local $^W = 0;
      my $s = substr($str,$i,$j);
      my $t = ShiftJIS::String::substr($zen,$i,$j);
      for($s,$t){$_ = 'undef' if ! defined $_;}
      ++$NG unless $s eq $printZ2H->($t);
    }
  }
  print ! $NG ? "ok 3\n" : "not ok 3\n";

  $NG = 0;
  for $i (-8..8){
    local $^W = 0;
    my $s = $str; 
    my $t = $zen;
    substr($s,$i) = "RE";
    ${ ShiftJIS::String::substr(\$t,$i) } = "‚q‚d";
    ++$NG unless $s eq $printZ2H->($t);
  }
  print ! $NG ? "ok 4\n" : "not ok 4\n";

  $NG = 0;
  for $i (-8..8){
    for $j (undef,-10..10){
      local $^W = 0;
      my $s = $str; 
      my $t = $zen;
      substr($s,$i,$j) = "RE";
      ${ ShiftJIS::String::substr(\$t,$i,$j) } = "‚q‚d";
      ++$NG unless $s eq $printZ2H->($t);
    }
  }
  print ! $NG ? "ok 5\n" : "not ok 5\n";

  $NG = 0;
  for $i (-8..8){
    for $j (-10..10){
      local $^W = 0;
      my $s = $str; 
      my $t = $zen;
      my $core = substr($s,$i,$j,"OK");
      my $sjis = ShiftJIS::String::substr($t,$i,$j,"‚n‚j");
      ++$NG unless $s eq $printZ2H->($t) && $core eq $printZ2H->($sjis);
    }
  }
  print ! $NG ? "ok 6\n" : "not ok 6\n";
}
