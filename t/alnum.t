# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..33\n"; }
END {print "not ok 1\n" unless $loaded;}
use ShiftJIS::String qw(strtr spaceH2Z spaceZ2H);

$^W = 1;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.
{
  my $NG;

  my $digitH = ShiftJIS::String::mkrange('0-9');
  my $digitZ = ShiftJIS::String::mkrange('‚O-‚X');
  my $lowerH = ShiftJIS::String::mkrange('a-z');
  my $lowerZ = ShiftJIS::String::mkrange('‚-‚š');
  my $upperH = ShiftJIS::String::mkrange('A-Z');
  my $upperZ = ShiftJIS::String::mkrange('‚`-‚y');
  my $alphaH = ShiftJIS::String::mkrange('A-Za-z');
  my $alphaZ = ShiftJIS::String::mkrange('‚`-‚y‚-‚š');
  my $alnumH = ShiftJIS::String::mkrange('0-9A-Za-z');
  my $alnumZ = ShiftJIS::String::mkrange('‚O-‚X‚`-‚y‚-‚š');

  my $digitZ2H = ShiftJIS::String::trclosure($digitZ, $digitH);
  my $upperZ2H = ShiftJIS::String::trclosure($upperZ, $upperH);
  my $lowerZ2H = ShiftJIS::String::trclosure($lowerZ, $lowerH);
  my $alphaZ2H = ShiftJIS::String::trclosure($alphaZ, $alphaH);
  my $alnumZ2H = ShiftJIS::String::trclosure($alnumZ, $alnumH);

  my $digitH2Z = ShiftJIS::String::trclosure($digitH, $digitZ);
  my $upperH2Z = ShiftJIS::String::trclosure($upperH, $upperZ);
  my $lowerH2Z = ShiftJIS::String::trclosure($lowerH, $lowerZ);
  my $alphaH2Z = ShiftJIS::String::trclosure($alphaH, $alphaZ);
  my $alnumH2Z = ShiftJIS::String::trclosure($alnumH, $alnumZ);

  for my $H ($digitH, $lowerH, $upperH){
    for my $tr ($digitZ2H, $upperZ2H, $lowerZ2H, $alphaZ2H, $alnumZ2H){
      ++$NG unless $H eq $tr->($H);
    }
  }
  print !$NG ? "ok" : "not ok", " 2\n";

  $NG = 0;
  for my $Z ($digitZ, $lowerZ, $upperZ){
    for my $tr ($digitH2Z, $upperH2Z, $lowerH2Z, $alphaH2Z, $alnumH2Z){
      ++$NG unless $Z eq $tr->($Z);
    }
  }
  print !$NG ? "ok" : "not ok", " 3\n";

  print $digitZ eq $digitH2Z->($digitH) ? "ok" : "not ok", " 4\n";
  print $digitH eq $upperH2Z->($digitH) ? "ok" : "not ok", " 5\n";
  print $digitH eq $lowerH2Z->($digitH) ? "ok" : "not ok", " 6\n";
  print $digitH eq $alphaH2Z->($digitH) ? "ok" : "not ok", " 7\n";
  print $digitZ eq $alnumH2Z->($digitH) ? "ok" : "not ok", " 8\n";
  print $upperH eq $digitH2Z->($upperH) ? "ok" : "not ok", " 9\n";
  print $upperZ eq $upperH2Z->($upperH) ? "ok" : "not ok", " 10\n";
  print $upperH eq $lowerH2Z->($upperH) ? "ok" : "not ok", " 11\n";
  print $upperZ eq $alphaH2Z->($upperH) ? "ok" : "not ok", " 12\n";
  print $upperZ eq $alnumH2Z->($upperH) ? "ok" : "not ok", " 13\n";
  print $lowerH eq $digitH2Z->($lowerH) ? "ok" : "not ok", " 14\n";
  print $lowerH eq $upperH2Z->($lowerH) ? "ok" : "not ok", " 15\n";
  print $lowerZ eq $lowerH2Z->($lowerH) ? "ok" : "not ok", " 16\n";
  print $lowerZ eq $alphaH2Z->($lowerH) ? "ok" : "not ok", " 17\n";
  print $lowerZ eq $alnumH2Z->($lowerH) ? "ok" : "not ok", " 18\n";
  print $digitH eq $digitZ2H->($digitZ) ? "ok" : "not ok", " 19\n";
  print $digitZ eq $upperZ2H->($digitZ) ? "ok" : "not ok", " 20\n";
  print $digitZ eq $lowerZ2H->($digitZ) ? "ok" : "not ok", " 21\n";
  print $digitZ eq $alphaZ2H->($digitZ) ? "ok" : "not ok", " 22\n";
  print $digitH eq $alnumZ2H->($digitZ) ? "ok" : "not ok", " 23\n";
  print $upperZ eq $digitZ2H->($upperZ) ? "ok" : "not ok", " 24\n";
  print $upperH eq $upperZ2H->($upperZ) ? "ok" : "not ok", " 25\n";
  print $upperZ eq $lowerZ2H->($upperZ) ? "ok" : "not ok", " 26\n";
  print $upperH eq $alphaZ2H->($upperZ) ? "ok" : "not ok", " 27\n";
  print $upperH eq $alnumZ2H->($upperZ) ? "ok" : "not ok", " 28\n";
  print $lowerZ eq $digitZ2H->($lowerZ) ? "ok" : "not ok", " 29\n";
  print $lowerZ eq $upperZ2H->($lowerZ) ? "ok" : "not ok", " 30\n";
  print $lowerH eq $lowerZ2H->($lowerZ) ? "ok" : "not ok", " 31\n";
  print $lowerH eq $alphaZ2H->($lowerZ) ? "ok" : "not ok", " 32\n";
  print $lowerH eq $alnumZ2H->($lowerZ) ? "ok" : "not ok", " 33\n";
}
