# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..9\n"; }
END {print "not ok 1\n" unless $loaded;}
use ShiftJIS::String qw(strtr spaceH2Z spaceZ2H);

$^W = 1;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.
{
  my $NG;

  my $digitH = ShiftJIS::String::mkrange('0-9');
  my $digitZ = ShiftJIS::String::mkrange('ÇO-ÇX');
  my $lowerH = ShiftJIS::String::mkrange('a-z');
  my $lowerZ = ShiftJIS::String::mkrange('ÇÅ-Çö');
  my $upperH = ShiftJIS::String::mkrange('A-Z');
  my $upperZ = ShiftJIS::String::mkrange('Ç`-Çy');
  my $alphaH = ShiftJIS::String::mkrange('A-Za-z');
  my $alphaZ = ShiftJIS::String::mkrange('Ç`-ÇyÇÅ-Çö');
  my $alnumH = ShiftJIS::String::mkrange('0-9A-Za-z');
  my $alnumZ = ShiftJIS::String::mkrange('ÇO-ÇXÇ`-ÇyÇÅ-Çö');

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

  my($H,$Z,$tr);
  for $H ($digitH, $lowerH, $upperH){
    for $tr ($digitZ2H, $upperZ2H, $lowerZ2H, $alphaZ2H, $alnumZ2H){
      ++$NG unless $H eq &$tr($H);
    }
  }
  print !$NG ? "ok" : "not ok", " 2\n";

  $NG = 0;
  for $Z ($digitZ, $lowerZ, $upperZ){
    for $tr ($digitH2Z, $upperH2Z, $lowerH2Z, $alphaH2Z, $alnumH2Z){
      ++$NG unless $Z eq &$tr($Z);
    }
  }
  print !$NG ? "ok" : "not ok", " 3\n";

  print $digitZ eq &$digitH2Z($digitH)
     && $digitH eq &$upperH2Z($digitH)
     && $digitH eq &$lowerH2Z($digitH)
     && $digitH eq &$alphaH2Z($digitH)
     && $digitZ eq &$alnumH2Z($digitH)
      ? "ok" : "not ok", " 4\n";
  print $upperH eq &$digitH2Z($upperH)
     && $upperZ eq &$upperH2Z($upperH)
     && $upperH eq &$lowerH2Z($upperH)
     && $upperZ eq &$alphaH2Z($upperH)
     && $upperZ eq &$alnumH2Z($upperH)
      ? "ok" : "not ok", " 5\n";
  print $lowerH eq &$digitH2Z($lowerH)
     && $lowerH eq &$upperH2Z($lowerH)
     && $lowerZ eq &$lowerH2Z($lowerH)
     && $lowerZ eq &$alphaH2Z($lowerH)
     && $lowerZ eq &$alnumH2Z($lowerH)
      ? "ok" : "not ok", " 6\n";
  print $digitH eq &$digitZ2H($digitZ)
     && $digitZ eq &$upperZ2H($digitZ)
     && $digitZ eq &$lowerZ2H($digitZ)
     && $digitZ eq &$alphaZ2H($digitZ)
     && $digitH eq &$alnumZ2H($digitZ)
      ? "ok" : "not ok", " 7\n";
  print $upperZ eq &$digitZ2H($upperZ)
     && $upperH eq &$upperZ2H($upperZ)
     && $upperZ eq &$lowerZ2H($upperZ)
     && $upperH eq &$alphaZ2H($upperZ)
     && $upperH eq &$alnumZ2H($upperZ)
      ? "ok" : "not ok", " 8\n";
  print $lowerZ eq &$digitZ2H($lowerZ)
     && $lowerZ eq &$upperZ2H($lowerZ)
     && $lowerH eq &$lowerZ2H($lowerZ)
     && $lowerH eq &$alphaZ2H($lowerZ)
     && $lowerH eq &$alnumZ2H($lowerZ)
      ? "ok" : "not ok", " 9\n";
}
