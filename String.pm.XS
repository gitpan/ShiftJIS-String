package ShiftJIS::String;

use Carp;
use strict;
use vars qw($VERSION $PACKAGE @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

$VERSION = '0.11';
$PACKAGE = 'ShiftJIS::String'; # __PACKAGE__

require Exporter;
require DynaLoader;
require AutoLoader;
@ISA = qw(Exporter DynaLoader);

%EXPORT_TAGS = (
    'issjis' => [ qw/issjis/ ],
    'string' => [ qw/length index rindex strspn strcspn strrev substr/ ],
    'ctype'  => [ qw/toupper tolower/ ],
    'tr'     => [ qw/mkrange strtr trclosure/ ],
    'kana'   => [ qw/hi2ka ka2hi hiXka/ ],
    'H2Z'    => [ qw/kataH2Z kanaH2Z spaceH2Z/ ],
    'Z2H'    => [ qw/kataZ2H kanaZ2H spaceZ2H/ ],
);

$EXPORT_TAGS{all}  = [ map @$_, values %EXPORT_TAGS ];
$EXPORT_TAGS{core} = [ map @$_, @EXPORT_TAGS{ qw/issjis string ctype tr/ } ];

@EXPORT_OK = @{ $EXPORT_TAGS{all} };
@EXPORT = ();

bootstrap ShiftJIS::String $VERSION;

my $Char = '(?:[\x81-\x9F\xE0-\xFC][\x00-\xFF]|[\x00-\xFF])';

##
## substr(STRING or SCALAR REF, OFFSET; LENGTH)
## substr(SCALAR, OFFSET, LENGTH, REPLACEMENT)
##
sub substr ($$;$$) {
    my($plen, $clen) = possubstr(@_);
    return if ! defined $plen;
    return (@_ > 3)
	? CORE::substr($_[0], $plen, $clen, $_[3])
	: (ref $_[0])
	? \ CORE::substr(${ $_[0] }, $plen, $clen)
	:   CORE::substr($_[0],  $plen, $clen);
}

##
## strtr(STRING or SCALAR REF, SEARCHLIST, REPLACEMENTLIST; 
##       MODIFIER, PATTERN, TOPATTERN)
##
my %Cache;

sub strtr($$$;$$$)
{
    my $str = shift;
    my $coderef = (defined $_[2] && $_[2] =~ /o/) 
	? ( $Cache{ join "\xFF", @_ } ||= trclosure(@_) )
	: trclosure(@_);
    &$coderef($str);
}

##
## trclosure(SEARCHLIST, REPLACEMENTLIST; MODIFIER, PATTERN, TOPATTERN)
##
sub trclosure($$;$$$)
{
  my(@fr, @to, $r, $R, $c, $d, $s, $i, %hash);
  my($fr, $to, $mod, $re, $tore) = @_;

  $r = defined $mod && $mod =~ /r/;
  $R = defined $mod && $mod =~ /R/;

  if (ref $fr) {
    @fr = @$fr;
    $re = defined $re ? "$re|$Char" :
       join('|', map(quotemeta($_), @$fr), $Char);
  } else {
    $fr = scalar mkrange($fr, $r) unless $R;
    $re = defined $re ? "$re|$Char" : $Char;
    @fr = $fr =~ /\G$re/g;
  }
  if (ref $to) {
    @to = @$to;
    $tore = defined $tore ? "$tore|$Char" :
       join('|', map(quotemeta($_), @$to), $Char);
  } else {
    $to = scalar mkrange($to, $r) unless $R;
    $tore = defined $tore ? "$tore|$Char" : $re;
    @to = $to =~ /\G$tore/g;
  }

  $c = defined $mod && $mod =~ /c/;
  $d = defined $mod && $mod =~ /d/;
  $s = defined $mod && $mod =~ /s/;
  $mod = $s * 4 + $d * 2 + $c;

  for ($i = 0; $i < @fr; $i++) {
    next if exists $hash{ $fr[$i] };
    $hash{ $fr[$i] } =
    @to ? defined $to[$i] ? $to[$i] : $d ? '' : $to[-1]
        : $d && !$c ? '' : $fr[$i];
  }
  return
    $mod == 3 || $mod == 7 ?
      sub { # $c: true, $d: true, $s: true/false, $mod: 3 or 7
        my $str = shift;
        my $cnt = 0;
        (ref $str ? $$str : $str) =~ s{($re)}{
          exists $hash{$1} ? $1 : (++$cnt, '');
        }ge;
        return ref $str ? $cnt : $str;
      } :
    $mod == 5 ?
      sub { # $c: true, $d: false, $s: true, $mod: 5
        my $str = shift;
        my $cnt = 0;
        my $pre = '';
        my $now;
        (ref $str ? $$str : $str) =~ s{($re)}{
          exists $hash{$1} ? ($pre = '', $1) : (++$cnt, 
            $now = @to ? $to[-1] : $1, 
            $now eq $pre ? '' : ($pre = $now) 
          );
        }ge;
        ref $str ? $cnt : $str;
      } :
    $mod == 4 || $mod == 6 ?
      sub { # $c: false, $d: true/false, $s: true, $mod: 4 or 6
        my $str = shift;
        my $cnt = 0;
        my $pre = '';
        (ref $str ? $$str : $str) =~ s{($re)}{
          exists $hash{$1} ? (++$cnt, 
             $hash{$1} eq '' || $hash{$1} eq $pre ? '' : ($pre = $hash{$1})
          ) : ($pre = '', $1);
        }ge;
        ref $str ? $cnt : $str;
      } :
    $mod == 1 ?
      sub { # $c: true, $d: false, $s: false, $mod: 1
        my $str = shift;
        my $cnt = 0;
        (ref $str ? $$str : $str) =~ s{($re)}{
          exists $hash{$1} ? $1 : (++$cnt, @to) ? $to[-1] : $1;
        }ge;
        ref $str ? $cnt : $str;
      } :
    $mod == 0 || $mod == 2 ?
      sub { # $c: false, $d: true/false, $s: false, $mod:  0 or 2
        my $str = shift;
        my $cnt = 0;
        (ref $str ? $$str : $str) =~ s{($re)}{
          exists $hash{$1} ? (++$cnt, $hash{$1}) : $1;
        }ge;
        ref $str ? $cnt : $str;
      } :
    sub { croak "$PACKAGE Panic! Invalid closure in trclosure!\n" }
}

1;
__END__
