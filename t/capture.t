# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

BEGIN { $| = 1; print "1..11\n"; }
END {print "not ok 1\n" unless $loaded;}

use ShiftJIS::String qw(:all);
$^W = 1;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

my $L82 = '(?:\x82[\x40-\xfc])';
my $L83 = '(?:\x83[\x40-\xfc])';

"‚`‚a‚bƒAƒCƒEƒGƒI" =~ /($L82+)($L83+)/;

print "‚`‚a‚b" eq $1 && "ƒAƒCƒEƒGƒI" eq $2
  ? "ok" : "not ok", " 2\n";

print length($1) == 3 && length($2) == 5
  ? "ok" : "not ok", " 3\n";

print strrev($1) eq "‚b‚a‚`" && strrev($2) eq "ƒIƒGƒEƒCƒA"
  ? "ok" : "not ok", " 4\n";

print "‚a‚b" eq substr($1,1,2) && "ƒEƒGƒI" eq substr($2,-3)
  ? "ok" : "not ok", " 5\n";

print "ABC" eq strtr($1,'‚`-‚y','A-Z')
    && "ƒAƒCƒEƒGƒI" eq strtr($2,'‚`-‚y','A-Z')
  ? "ok" : "not ok", " 6\n";

print "‚`‚a‚b" eq strtr($1,'ƒA-ƒ“','‚ -‚ñ')
     && "‚ ‚¢‚¤‚¦‚¨" eq strtr($2,'ƒA-ƒ“','‚ -‚ñ')
  ? "ok" : "not ok", " 7\n";

print "‚`‚a‚b" eq $1 && "ƒAƒCƒEƒGƒI" eq $2
  ? "ok" : "not ok", " 8\n";

my $str = "‚`‚a‚bƒAƒCƒEƒGƒI“““‚w‚x‚yƒnƒqƒtƒwƒz";

$str =~ s/($L82+)($L83+)/
    strtr($1,'‚`-‚y','A-Z'). strtr($2,'ƒA-ƒ“','‚ -‚ñ')
/ge;

print $str eq "ABC‚ ‚¢‚¤‚¦‚¨“““XYZ‚Í‚Ğ‚Ó‚Ö‚Ù"
  ? "ok" : "not ok", " 9\n";

$str =~ s/($L82+)/strrev(substr($1,1,3))/ge;

print $str eq "ABC‚¦‚¤‚¢“““XYZ‚Ö‚Ó‚Ğ"
  ? "ok" : "not ok", " 10\n";

$str =~ s/($L82+)/length($1)/ge;

print $str eq "ABC3“““XYZ3"
  ? "ok" : "not ok", " 11\n";

1;
__END__
