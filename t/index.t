# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

BEGIN { $| = 1; print "1..10\n"; }
END {print "not ok 1\n" unless $loaded;}

use ShiftJIS::String qw(index rindex);
$^W = 1;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

print index("", ""    )   eq CORE::index("", ""    )
   && index("", "", -1)   eq CORE::index("", "", -1)
   && index("", "",  0)   eq CORE::index("", "",  0)
   && index("", "",  1)   eq CORE::index("", "",  1)
   && index("", "", 10)   eq CORE::index("", "", 10)
   && index("", "a"   )   eq CORE::index("", "a"   )
   && index("", "a", -1)  eq CORE::index("", "a", -1)
   && index("", "a",  0)  eq CORE::index("", "a",  0)
   && index("", "a",  1)  eq CORE::index("", "a",  1)
   && index("", "a", 10)  eq CORE::index("", "a", 10)
   && index(" a", ""    ) eq CORE::index(" a", ""    )
   && index(" a", "", -1) eq CORE::index(" a", "", -1)
   && index(" a", "",  0) eq CORE::index(" a", "",  0)
   && index(" a", "",  1) eq CORE::index(" a", "",  1)
   && index(" a", "",  2) eq CORE::index(" a", "",  2)
   && index(" a", "", 10) eq CORE::index(" a", "", 10)
  ? "ok" : "not ok", " 2\n";

print index(" a", "a"   ) eq CORE::index(" a", "a"   )
   && index(" a", "a",-1) eq CORE::index(" a", "a",-1)
   && index(" a", "a", 0) eq CORE::index(" a", "a", 0)
   && index(" a", "a", 1) eq CORE::index(" a", "a", 1)
   && index(" a", "a", 2) eq CORE::index(" a", "a", 2)
   && index(" a", "a",10) eq CORE::index(" a", "a",10)
   && index("a", "ab",-1) eq CORE::index("a", "ab",-1)
   && index("a", "ab", 0) eq CORE::index("a", "ab", 0)
   && index("a", "ab", 1) eq CORE::index("a", "ab", 1)
   && index("a", "ab", 2) eq CORE::index("a", "ab", 2)
   && index("a", "ab",10) eq CORE::index("a", "ab",10)
  ? "ok" : "not ok", " 3\n";

print rindex("", ""    )   eq CORE::rindex("", "")
   && rindex("", "", -1)   eq CORE::rindex("", "", -1)
   && rindex("", "",  0)   eq CORE::rindex("", "",  0)
   && rindex("", "",  1)   eq CORE::rindex("", "",  1)
   && rindex("", "", 10)   eq CORE::rindex("", "", 10)
   && rindex("", "a"    )  eq CORE::rindex("", "a"    )
   && rindex("", "a", -1)  eq CORE::rindex("", "a", -1)
   && rindex("", "a",  0)  eq CORE::rindex("", "a",  0)
   && rindex("", "a",  1)  eq CORE::rindex("", "a",  1)
   && rindex("", "a", 10)  eq CORE::rindex("", "a", 10)
   && rindex(" a", ""    ) eq CORE::rindex(" a", ""    )
   && rindex(" a", "", -1) eq CORE::rindex(" a", "", -1)
   && rindex(" a", "",  0) eq CORE::rindex(" a", "",  0)
   && rindex(" a", "",  1) eq CORE::rindex(" a", "",  1)
   && rindex(" a", "",  2) eq CORE::rindex(" a", "",  2)
   && rindex(" a", "", 10) eq CORE::rindex(" a", "", 10)
  ? "ok" : "not ok", " 4\n";

print rindex(" a", "a"   ) eq CORE::rindex(" a", "a"   )
   && rindex(" a", "a",-1) eq CORE::rindex(" a", "a",-1)
   && rindex(" a", "a", 0) eq CORE::rindex(" a", "a", 0)
   && rindex(" a", "a", 1) eq CORE::rindex(" a", "a", 1)
   && rindex(" a", "a", 2) eq CORE::rindex(" a", "a", 2)
   && rindex(" a", "a",10) eq CORE::rindex(" a", "a",10)
   && rindex("a", "ab",-1) eq CORE::rindex("a", "ab",-1)
   && rindex("a", "ab", 0) eq CORE::rindex("a", "ab", 0)
   && rindex("a", "ab", 1) eq CORE::rindex("a", "ab", 1)
   && rindex("a", "ab", 2) eq CORE::rindex("a", "ab", 2)
   && rindex("a", "ab",10) eq CORE::rindex("a", "ab",10)
  ? "ok" : "not ok", " 5\n";

{
  my $str = '+0.1231425126-*12346';
  my $zen = 'Å{ÇOÅDÇPÇQ3ÇPÇSÇQÇTÇPÇQ6-ÅñÇPÇQÇR4ÇU';
  my $sub = '12';
  my $sbz = 'ÇPÇQ';
  my($pos,$si, $bi);

  my $n = 1;
  my $NG;
  $NG = 0;
  for $pos (-10..18){
    $si = CORE::index($str,$sub,$pos);
    $bi = index($zen,$sbz,$pos);
    $NG++ if $si != $bi;
  }
  print !$NG ? "ok" : "not ok", " 6\n";

  $NG = 0;
  for $pos (-10..16){
    $si = CORE::rindex($str,$sub,$pos);
    $bi = rindex($zen,$sbz,$pos);
    $NG++ if $si != $bi;
  }
  print !$NG ? "ok" : "not ok", " 7\n";
}

{
  my $str = 'a'  x 10;
  my $zen = 'Ç†' x 10;
  my $sub = 'a';
  my $sbz = 'Ç†';
  my($pos,$si, $bi);

  my $n = 1;
  my $NG;
  $NG = 0;
  $si = CORE::index($str,$sub);
  $bi = index($zen,$sbz);
  $NG++ if $si != $bi;
  for $pos (-10..18){
    $si = CORE::index($str,$sub,$pos);
    $bi = index($zen,$sbz,$pos);
    $NG++ if $si != $bi;
  }
  print !$NG ? "ok" : "not ok", " 8\n";

  $NG = 0;
  $si = CORE::rindex($str,$sub);
  $bi = rindex($zen,$sbz);
  $NG++ if $si != $bi;
  for $pos (-10..16){
    $si = CORE::rindex($str,$sub,$pos);
    $bi = rindex($zen,$sbz,$pos);
    $NG++ if $si != $bi;
  }
  print !$NG ? "ok" : "not ok", " 9\n";
}

print index ("a\0c",  "a\0b")   eq CORE::index ("a\0c", "a\0b")
  &&  rindex("a\0c",  "a\0b")   eq CORE::rindex("a\0c", "a\0b")
  &&  index ("aca\0", "a\0\0")  eq CORE::index ("aca\0", "a\0\0")
  &&  rindex("aca\0", "a\0\0")  eq CORE::rindex("aca\0", "a\0\0")
  ? "ok" : "not ok", " 10\n";
