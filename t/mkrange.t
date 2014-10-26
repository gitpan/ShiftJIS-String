# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

BEGIN { $| = 1; print "1..16\n"; }
END {print "not ok 1\n" unless $loaded;}
use ShiftJIS::String qw(mkrange strrev);

$^W = 1;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

print mkrange("") eq ""
   && mkrange('-+\-XYZ-') eq "-+-XYZ-"
  ? "ok" : "not ok", " 2\n";
print join(':', mkrange "A-D") eq "A:B:C:D"
   && mkrange('p-e-r-l', 1) eq 'ponmlkjihgfefghijklmnopqrqponml'
   && mkrange("��-��") eq "������������"
   && mkrange("A\000B\000C") eq "A\000B\000C"
  ? "ok" : "not ok", " 3\n";
print mkrange("0-9�O-�X") eq "0123456789�O�P�Q�R�S�T�U�V�W�X"
  ? "ok" : "not ok", " 4\n";

eval { mkrange("9-0") };
print $@
  ? "ok" : "not ok", " 5\n";

eval { mkrange('-��-�����y-�`') };
print $@
  ? "ok" : "not ok", " 6\n";

print mkrange("0-9")   eq "0123456789"
  &&  mkrange("0-9",1) eq "0123456789"
  ? "ok" : "not ok", " 7\n";
print mkrange("9-0",1) eq "9876543210"
   && mkrange("Q-E",1) eq "QPONMLKJIHGFE"
  ? "ok" : "not ok", " 8\n";
print mkrange('�\-') eq '�\-'
   && mkrange('ab-') eq 'ab-'
  ? "ok" : "not ok", " 9\n";

print strrev(mkrange('9-0',1))   eq '0123456789'
  ? "ok" : "not ok", " 10\n";
print strrev(mkrange('�r-��',1)) eq mkrange('��-�r')
  ? "ok" : "not ok", " 11\n";
print strrev(mkrange('�-�',1))   eq mkrange('�-�')
  ? "ok" : "not ok", " 12\n";
print strrev(mkrange('��-����-�@',1)) eq mkrange('�@-����-��')
  ? "ok" : "not ok", " 13\n";
print strrev(mkrange('��-��',1)) eq mkrange('��-��')
  ? "ok" : "not ok", " 14\n";
print strrev(mkrange('9-0',1))   eq '0123456789'
  ? "ok" : "not ok", " 15\n";
print strrev(mkrange("\x81\x40-\x00",1)) eq mkrange("\x00-\x81\x40")
  ? "ok" : "not ok", " 16\n";
