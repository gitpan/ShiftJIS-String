package ShiftJIS::String;

use strict;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

use Carp;

require Exporter;

@ISA = qw(Exporter);

@EXPORT = qw();

@EXPORT_OK = qw(
  issjis length strrev toupper tolower index rindex strspn strcspn
  splitspace splitchar substr mkrange strtr trclosure
  kataH2Z kanaH2Z kataZ2H kanaZ2H hi2ka ka2hi hiXka spaceH2Z spaceZ2H
);

$VERSION = '0.06';

my $Char = '(?:[\x00-\x7F\xA1-\xDF]|[\x81-\x9F\xE0-\xFC][\x40-\x7E\x80-\xFC])';

############################################################################
#
# issjis(LIST)
#
############################################################################
sub issjis{
   !grep !
   /^(?:[\x00-\x7F\xA1-\xDF]|[\x81-\x9F\xE0-\xFC][\x40-\x7E\x80-\xFC])*$/,
   @_;
}

############################################################################
#
# tolower(STRING)
#
############################################################################
sub tolower {
  my $str = $_[0];
  $str =~ s/\G($Char*?)([A-Z]+)/$1\L$2/g;
  return $str;
}

############################################################################
#
# toupper(STRING)
#
############################################################################
sub toupper {
  my $str = $_[0];
  $str =~ s/\G($Char*?)([a-z]+)/$1\U$2/g;
  return $str;
}

############################################################################
#
# length(STRING)
# 
############################################################################
sub length{
    scalar( (my $str = shift) =~ s/$Char//go );
}

############################################################################
#
# strrev(STRING)
# 
############################################################################
sub strrev{
    my $str = shift;
    join '', reverse _splitchar($str);
}

sub _splitchar{ $_[0] =~ /$Char/go }

############################################################################
#
# index(STRING, SUBSTR; POSITION)
# 
############################################################################
sub index{
  my $str = shift;
  my $sub = quotemeta shift;
  my $pos = shift;
  $pos = 0 if $pos < 0;
  if($pos){
    ${ &substr(\$str,$pos) } =~ /^($Char*?)$sub/;
    my $head = $1;
    defined $head ? $pos + &length($head) : -1;
  } else {
    $str =~ /^($Char*?)$sub/;
    my $head = $1;
    defined $head ? &length($head) : -1;
  }
}

############################################################################
#
# rindex(STRING, SUBSTR; POSITION)
# 
############################################################################
sub rindex{
  my($str,$sub,$pos) = @_;
  my $pat = quotemeta $sub;
  return -1 if $pos < 0;
  (defined $pos ? ${ &substr(\$str, 0, $pos + &length($sub)) } : $str) =~
     /^($Char*)$pat/;
  my $head = $1;
  defined $head ? &length($head) : -1;
}

############################################################################
#
# strspn(STRING, SEARCHLIST)
#
############################################################################
sub strspn{
  my($str, $lst, %lst, $pos);
  ($str, $lst) = @_;
  $pos = 0;
  @lst{ $lst=~ /$Char/go } = ();
  while($str =~ /($Char)/go){
    last if ! exists $lst{$1};
    $pos++;
  }
  return $pos;
}

############################################################################
#
# strcspn(STRING, SEARCHLIST)
#
############################################################################
sub strcspn{
  my($str, $lst, %lst, $pos);
  ($str, $lst) = @_;
  $pos = 0;
  @lst{ $lst=~ /$Char/go } = ();
  while($str =~ /($Char)/go){
    last if exists $lst{$1};
    $pos++;
  }
  return $pos;
}

############################################################################
#
# substr(STRING or SCALAR REF, OFFSET; LENGTH)
# substr(SCALAR, OFFSET, LENGTH, REPLACEMENT)
# 
############################################################################
sub substr{
  my(@chars, $slen, $ini, $fin, $except);
  my($str, $off, $len, $rep) = @_;
  $slen = @chars = _splitchar(ref $str ? $$str : $str);
  $except = 1 if $slen < $off;
  if(@_ == 2){$len = $slen - $off;}
  else {
    $except = 1 if $off + $slen < 0 && $len + $slen < 0;
    $except = 1 if 0 <= $len && $off + $len + $slen < 0;
  }
  if($except){
    if(@_ > 3){croak "substr outside of string"} else {return}
  }
  $ini = $off < 0 ? $slen + $off : $off;
  $fin = $len < 0 ? $slen + $len : $ini + $len;
  $ini = 0     if $ini < 0;
  $fin = $ini  if $ini > $fin;
  $ini = $slen if $slen < $ini;
  $fin = $slen if $slen < $fin;

  if(@_ > 3){
     $_[0] = join '', @chars[0..$ini-1],$rep,@chars[$fin..@chars-1]
  }
  return ref $str
    ? \ CORE::substr($$str,
              CORE::length(join '', @chars[0..$ini-1]),
              CORE::length(join '', @chars[$ini..$fin-1])
      )
    : join '', @chars[$ini..$fin-1]
}

############################################################################
#
# strtr(STRING or SCALAR REF, SEARCHLIST, REPLACEMENTLIST; 
#       MODIFIER, PATTERN, TOPATTERN)
#
############################################################################
my %Cache;

sub strtr {
  my $str = shift;
  if(defined $_[2] && $_[2] =~ /o/){
    my $k = join "\xFF", @_;
    ($Cache{$k} ||= trclosure(@_))->($str);
  }
  else {
    trclosure(@_)->($str);
  }
}

sub spaceZ2H {
  my $str = shift;
  my $len = CORE::length(ref $str ? $$str : $str);
  (ref $str ? $$str : $str) =~
     s/\G($Char*?)\x81\x40/$1 /go;
  ref $str ? abs($len - CORE::length $$str) : $str;
};

sub spaceH2Z {
  my $str = shift;
  my $len = CORE::length(ref $str ? $$str : $str);
  (ref $str ? $$str : $str) =~ s/ /\x81\x40/g;
  ref $str ? abs($len - CORE::length $$str) : $str;
};

############################################################################
#
# trclosure(SEARCHLIST, REPLACEMENTLIST; MODIFIER, PATTERN, TOPATTERN)
#
############################################################################
sub trclosure {
  my(@fr, @to, $r, $R, $c, $d, $s, $i, %hash);
  my($fr, $to, $mod, $re, $tore) = @_;

  $r = defined $mod && $mod =~ /r/;
  $R = defined $mod && $mod =~ /R/;

  if(ref $fr){
    @fr = @$fr;
    $re = defined $re ? "$re|$Char" :
       join('|', map(quotemeta, @$fr), $Char);
  } else {
    $fr = scalar mkrange($fr, $r) unless $R;
    $re = defined $re ? "$re|$Char" : $Char;
    @fr = $fr =~ /\G$re/g;
  }
  if(ref $to){
    @to = @$to;
    $tore = defined $tore ? "$tore|$Char" :
       join('|', map(quotemeta, @$to), $Char);
  } else {
    $to = scalar mkrange($to, $r) unless $R;
    $tore = defined $tore ? "$tore|$Char" : $re;
    @to = $to =~ /\G$tore/g;
  }

  $c = defined $mod && $mod =~ /c/;
  $d = defined $mod && $mod =~ /d/;
  $s = defined $mod && $mod =~ /s/;
  $mod = $s * 4 + $d * 2 + $c;

  for($i = 0; $i < @fr; $i++){
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
      } : sub { croak "Error! Invalid Closure!\n" }
}

###########################################################################
#
# mkrange(STRING, BOOL)
#
############################################################################

sub mkrange{
  my($s, @retv, $range);
  my($self,$rev) = @_;
  $self =~ s/^-/\\-/;
  $self =~ s/\\?-$/\\-/;
  $range = 0;
  foreach $s ($self =~ /\\\\|\\-|$Char/go){
    if($range){
      if   ($s eq '\\-') {$s = '-'}
      elsif($s eq '\\\\'){$s = '\\'}
      my $min = @retv ? __ord(pop(@retv)) : 1;
      my $max = __ord($s);
      push @retv, __expand($min,$max,$rev);
      $range = 0;
    }
    else {
      if($s eq '-'){$range = 1}
      elsif($s eq '\\-') {push @retv, '-' }
      elsif($s eq '\\\\'){push @retv, '\\'}
      else		 {push @retv, $s }
    }
  }
  wantarray ? @retv : @retv ? join('', @retv) : '';
}

sub __ord{
  my $c = shift;
  CORE::length($c) > 1 ? unpack('n', $c) : ord($c);
}

sub __expand{
  my($ini, $fin, $i, $ch, @retv);
  my($fr, $to, $rev) = @_;
  if($fr > $to){ if($rev){($fr,$to) = ($to,$fr)} else {return} }
  else {$rev = 0}
  if($fr <= 0x7F){
    $ini = $fr < 0x00 ? 0x00 : $fr;
    $fin = $to > 0x7F ? 0x7F : $to;
    for($i = $ini; $i <= $fin; $i++){push @retv, chr($i)}
  }
  if($fr <= 0xDF){
    $ini = $fr < 0xA1 ? 0xA1 : $fr;
    $fin = $to > 0xDF ? 0xDF : $to;
    for($i = $ini; $i <= $fin; $i++){push @retv, chr($i)}
  }
  $ini = $fr < 0x8140 ? 0x8140 : $fr;
  $fin = $to > 0xFCFC ? 0xFCFC : $to;
  if($ini <= $fin){
    my($ini_f,$ini_t) = unpack 'C*', pack 'n', $ini;
    my($fin_f,$fin_t) = unpack 'C*', pack 'n', $fin;
    $ini_t = 0x40 if $ini_t < 0x40;
    $fin_t = 0xFC if $fin_t > 0xFC;
    if($ini_f == $fin_f){
      my $ch = chr $ini_f;
      for($i = $ini_t; $i <= $fin_t; $i++){
        next if $i == 0x7F;
        push @retv, $ch.chr($i);
      }
    }
    else {
      $ch = chr $ini_f;
      for($i = $ini_t; $i <= 0xFC; $i++){
        next if $i == 0x7F;
        push @retv, $ch.chr($i);
      }
      for($i = $ini_f+1; $i < $fin_f; $i++){
        next if 0xA0 <= $i && $i <= 0xDF;
        $ch = chr($i);
        push @retv, map $ch.chr, 0x40..0x7E, 0x80..0xFC;
      }
      $ch = chr $fin_f;
      for($i = 0x40; $i <=  $fin_t; $i++){
        next if $i == 0x7F;
        push @retv, $ch.chr($i);
      }
    }
  }
  return $rev ? reverse(@retv) : @retv;
}

############################################################################
#
# Kana Letter
#
############################################################################


my $kataTRE = '(?:[\xB3\xB6-\xC4\xCA-\xCE]\xDE|[\xCA-\xCE]\xDF)';
my $hiraTRE = '(?:\x82\xA4\x81\x4A)';
my $kanaTRE = "(?:$hiraTRE|$kataTRE)";

my $kataH
 = '｡｢｣､･ｦｧｨｩｪｫｬｭｮｯｰｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀ'
 . 'ﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝﾞﾟ'
 . 'ｶﾞｷﾞｸﾞｹﾞｺﾞｻﾞｼﾞｽﾞｾﾞｿﾞﾀﾞﾁﾞﾂﾞﾃﾞﾄﾞﾊﾞﾋﾞﾌﾞﾍﾞﾎﾞﾊﾟﾋﾟﾌﾟﾍﾟﾎﾟ'
 . 'ｳﾞｲｴﾜｶｹ';

my $kataZH
 = '。「」、・ヲァィゥェォャュョッーアイウエオカキクケコサシスセソタ'
 . 'チツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワン゛゜'
 . 'ガギグゲゴザジズゼゾダヂヅデドバビブベボパピプペポ'
 . 'ヴヰヱヮヵヶ';

my $hiraZH
 = '。「」、・をぁぃぅぇぉゃゅょっーあいうえおかきくけこさしすせそた'
 . 'ちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわん゛゜'
 . 'がぎぐげござじずぜぞだぢづでどばびぶべぼぱぴぷぺぽ'
 . 'う゛ゐゑゎかけ';


my $kataH2Z = trclosure($kataH, $kataZH, 'R', $kanaTRE);
my $kataZ2H = trclosure($kataZH, $kataH, 'R', $kanaTRE);
my $kanaZ2H = trclosure($hiraZH.$kataZH, $kataH.$kataH, 'R', $kanaTRE);

my $kataZ
 = 'ヲァィゥェォャュョッアイウエオカキクケコサシスセソタ'
 . 'チツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワン'
 . 'ガギグゲゴザジズゼゾダヂヅデドバビブベボパピプペポ'
 . 'ヴヰヱヮヵヶヽヾ';

my $hiraZ
 = 'をぁぃぅぇぉゃゅょっあいうえおかきくけこさしすせそた'
 . 'ちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわん'
 . 'がぎぐげござじずぜぞだぢづでどばびぶべぼぱぴぷぺぽ'
 . 'う゛ゐゑゎかけゝゞ';

my $hiXka = trclosure($kataZ.$hiraZ, $hiraZ.$kataZ, 'R', $hiraTRE);
my $hi2ka = trclosure($hiraZ, $kataZ, 'R', $hiraTRE);
my $ka2hi = trclosure($kataZ, $hiraZ, 'R', $hiraTRE);

sub kataH2Z { $kataH2Z->(@_) }
sub kanaH2Z { $kataH2Z->(@_) }
sub kataZ2H { $kataZ2H->(@_) }
sub kanaZ2H { $kanaZ2H->(@_) }
sub hiXka   { $hiXka -> (@_) }
sub hi2ka   { $hi2ka -> (@_) }
sub ka2hi   { $ka2hi -> (@_) }

1;
__END__

=head1 NAME

ShiftJIS::String - Perl module to deal with
Japanese strings in Shift_JIS encoding.

=head1 SYNOPSIS

  use ShiftJIS::String;

  ShiftJIS::String::substr($str, ShiftJIS::String::index($str, $substr));

=head1 DESCRIPTION

This module provides some functions which emulate
the corresponding C<CORE> functions and helps someone 
to manipulate multiple-byte character sequences in Shift_JIS encoding.

* 'Hankaku' and 'Zenkaku' mean 'halfwidth' and 'fullwidth' characters 
in Japanese, respectively. 

=head1 FUNCTIONS

=head2 Check Whether the String is Legal

=over 4

=item C<issjis(LIST)>

Returns a boolean indicating whether all the strings in the parameter list
are legally encoded in Shift_JIS.

=back

=head2 Length

=over 4

=item C<length(STRING)>

Returns the length in characters of the supplied string.

=back

=head2 Reverse

=over 4

=item C<strrev(STRING)>

Returns a reversed string.

=back

=head2 Case of the Alphabet

=over 4

=item C<toupper(STRING)>

Returns an uppercased string of C<STRING>.
Alters half-width Latin characters C<a-z> only.

=item C<tolower(STRING)>

Returns a lowercased string of C<STRING>.
Alters half-width Latin characters C<A-Z> only.

=back

=head2 Search

=over 4

=item C<index(STRING, SUBSTR)>

=item C<index(STRING, SUBSTR, POSITION)>

Returns the position of the first occurrence
of C<SUBSTR> in C<STRING> at or after C<POSITION>.
If C<POSITION> is omitted, starts searching 
from the beginning of the string. 

If the substring is not found, returns -1. 

=item C<rindex(STRING, SUBSTR)>

=item C<rindex(STRING, SUBSTR, POSITION)>

Returns the position of the last occurrence 
of C<SUBSTR> in C<STRING> at or after C<POSITION>.
If C<POSITION> is specified, returns the last 
occurrence at or before that position. 

If the substring is not found, returns -1. 

=item C<strspn(STRING, SEARCHLIST)>

Returns returns the position of the first occurrence of 
any character not contained in the search list.

  strspn("+0.12345*12", "+-.0123456789");
  # returns 8. 

If the specified string does not contain any character
in the search list, returns 0.

The string consists of characters in the search list, 
the returned value equals the length of the string.

=item C<strcspn(STRING, SEARCHLIST)>

Returns returns the position of the first occurrence of 
any character contained in the search list.

  strcspn("Perlは面白い。", "赤青黄白黒");
  # returns 6. 

If the specified string does not contain any character
in the search list,
the returned value equals the length of the string.

=back

=head2 Substring

=over 4

=item C<substr(STRING or SCALAR REF, OFFSET)>

=item C<substr(STRING or SCALAR REF, OFFSET, LENGTH)>

=item C<substr(SCALAR, OFFSET, LENGTH, REPLACEMENT)>

It works like C<CORE::substr>, but
using character semantics of Shift_JIS encoding.

If the C<REPLACEMENT> as the fourth parameter is specified, replaces
parts of the C<SCALAR> and returns what was there before.

You can utilize the lvalue reference,
returned if a reference of scalar variable is used as the first argument.

    ${ &substr(\$str,$off,$len) } = $replace;

        works like

    CORE::substr($str,$off,$len) = $replace;

The returned lvalue is not Shift_JIS-oriented but byte-oriented,
then successive assignment may cause unexpected results.

    $str = "0123456789";
    $lval  = &substr(\$str,3,1);
    $$lval = "あい";
    $$lval = "a";
    # $str is NOT "012aい456789", but an illegal string "012a\xA0い456789".

=back

=head2 Character Range

=over 4

=item C<mkrange(EXPR, EXPR)>

Returns the character list (not in list context, as a concatenated string)
gained by parsing the specified character range.

A character range is specified with a HYPHEN-MINUS, C<'-'>. The backslashed 
combinations C<'\-'> and C<'\\'> are used instead of the characters
C<'-'> and C<'\'>, respectively. The hyphen at the beginning or 
end of the range is also evaluated as the hyphen itself.

For example, C<mkrange('+\-0-9a-fA-F')> returns
C<('+', '-', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
'a', 'b', 'c', 'd', 'e', 'f', 'A', 'B', 'C', 'D', 'E', 'F')>
and C<scalar mkrange('か-ご')> returns C<'かがきぎくぐけげこご'>.

The order of Shift_JIS characters is:
  C<0x00 .. 0x7F, 0xA1 .. 0xDF, 0x8140 .. 0x9FFC, 0xE040 .. 0xFCFC>.
So, mkrange('亜-腕') returns the list of all characters in level 1 Kanji.

If true value is specified as the second parameter,
allows to use reverse character ranges such as C<'9-0'>, C<'Z-A'>.

=back

=head2 Transliteration

=over 4

=item C<strtr(STRING or SCALAR REF, SEARCHLIST, REPLACEMENTLIST)>

=item C<strtr(STRING or SCALAR REF, SEARCHLIST, REPLACEMENTLIST, MODIFIER)>

=item C<strtr(STRING or SCALAR REF, SEARCHLIST, REPLACEMENTLIST, MODIFIER, PATTERN)>

=item C<strtr(STRING or SCALAR REF, SEARCHLIST, REPLACEMENTLIST, MODIFIER, PATTERN, TOPATTERN)>

Transliterates all occurrences of the characters found in the search list
with the corresponding character in the replacement list. 

If a reference of scalar variable is specified as the first argument,
returns the number of characters replaced or deleted;
otherwise, returns the transliterated string and
the specified string is unaffected.

  $str = "なんといおうか";
  print strtr(\$str,"あいうえお", "アイウエオ"), "  ", $str;
  # output: 3  なんとイオウか

  $str = "後門の狼。";
  print strtr($str,"後狼。", "前虎、"), $str;
  # output: 前門の虎、後門の狼。

B<SEARCHLIST and REPLACEMENTLIST>

Character ranges such as C<"ぁ-お"> (internally utilizing C<mkrange()>)
are supported.

If the C<REPLACEMENTLIST> is empty (specified as C<''>, not C<undef>,
because the use of uninitialized value causes warning under -w option),
the C<SEARCHLIST> is replicated. 

If the replacement list is shorter than the search list,
the final character in the replacement list
is replicated till it is long enough
(but differently works when the 'd' modifier is used).

  strtr(\$str, 'ぁ-んァ-ヶｦ-ﾟ', '#');
    # replaces all Kana letters by '#'. 

B<MODIFIER>

    c   Complement the SEARCHLIST.
    d   Delete found but unreplaced characters.
    s   Squash duplicate replaced characters.
    R   No use of character ranges.
    r   Allows to use reverse character ranges.
    o   Caches the conversion table internally.

  strtr(\$str, 'ぁ-んァ-ヶｦ-ﾟ', '');
    # counts all Kana letters in $str. 

  $onlykana = strtr($str, 'ぁ-んァ-ヶｦ-ﾟ', '', 'cd');
    # deletes all characters except Kana. 

  strtr(\$str, " \x81\x40\n\r\t\f", '', 'd');
    # deletes all whitespace characters including full-width space

  strtr("おかかうめぼし　ちちとはは", 'ぁ-ん', '', 's');
    # output: おかうめぼし　ちとは

  strtr("条件演算子の使いすぎは見苦しい", 'ぁ-ん', '＃', 'cs');
    # output: ＃の＃いすぎは＃しい

If C<'R'> modifier is specified, C<'-'> is not evaluated as a meta character
but hyphen itself like in C<tr'''>. Compare:

  strtr("90 - 32 = 58", "0-9", "A-J");
    # output: "JA - DC = FI"

  strtr("90 - 32 = 58", "0-9", "A-J", "R");
    # output: "JA - 32 = 58"
    # cf. ($str = "90 - 32 = 58") =~ tr'0-9'A-J';
    # '0' to 'A', '-' to '-', and '9' to 'J'.

If C<'r'> modifier is specified, you are allowed to use reverse
character ranges. For example, C<strtr($str, "0-9", "9-0", "r")>
is identical to C<strtr($str, "0123456789", "9876543210")>.

  strtr($text, '亜-腕', '腕-亜', "r");
    # Your text may seem to be clobbered.

B<PATTERN and TOPATTERN>

By use of C<PATTERN> and C<TOPATTERN>, you can transliterate the string
using lists containing some multi-character substrings.

If called with four arguments, C<SEARCHLIST>, C<REPLACEMENTLIST>
and C<STRING> are splited characterwise;

If called with five arguments, a multi-character substring
that matchs C<PATTERN> in C<SEARCHLIST>, C<REPLACEMENTLIST> or C<STRING>
is regarded as an transliteration unit.

If both C<PATTERN> and C<TOPATTERN> are specified,
a multi-character substring 
either that matchs C<PATTERN> in C<SEARCHLIST> or C<STRING>,
or that matchs C<TOPATTERN> in C<REPLACEMENTLIST>
is regarded as an transliteration unit.

  print strtr(
    "Caesar Aether Goethe", 
    "aeoeueAeOeUe", 
    "&auml;&ouml;&ouml;&Auml;&Ouml;&Uuml;", 
    "", 
    "[aouAOU]e",
    "&[aouAOU]uml;");

  # output: C&auml;sar &Auml;ther G&ouml;the

B<LIST as Anonymous Array>

Instead of specification of C<PATTERN> and C<TOPATTERN>, you can use 
anonymous arrays as C<SEARCHLIST> and/or C<REPLACEMENTLIST> as follows.

  print strtr(
    "Caesar Aether Goethe", 
    [qw/ae oe ue Ae Oe Ue/], 
    [qw/&auml; &ouml; &ouml; &Auml; &Ouml; &Uuml;/]
  );

B<Caching the conversion table>

If 'o' modifier is specified, the conversion table is cached internally.
e.g.

  foreach(@hiragana_strings){
    print strtr($_, 'ぁ-ん', 'ァ-ン', 'o');
  }
  # katakana strings are printed

will be almost as efficient as this:

  $hiragana_to_katakana = trclosure('ぁ-ん', 'ァ-ン');

  foreach(@hiragana_strings){
    print &$hiragana_to_katakana($_);
  }

You can use whichever you like.

Without 'o',

  foreach(@hiragana_strings){
    print strtr($_, 'ぁ-ん', 'ァ-ン');
  }

will be very slow since the conversion table is made
whenever the function is called.

=back

=head2 Generation of the Closure to Transliterate

=over 4

=item C<trclosure(SEARCHLIST, REPLACEMENTLIST)>

=item C<trclosure(SEARCHLIST, REPLACEMENTLIST, MODIFIER)>

=item C<trclosure(SEARCHLIST, REPLACEMENTLIST, MODIFIER, PATTERN)>

=item C<trclosure(SEARCHLIST, REPLACEMENTLIST, MODIFIER, PATTERN, TOPATTERN)>

Returns a closure to transliterate the specified string.
The return value is an only code reference, not blessed object.
By use of this code ref, you can save yourself time
as you need not specify the parameter list every time.

  my $digit_tr = trclosure("1234567890-", "一二三四五六七八九〇－");
  print &$digit_tr("TEL ：0124-45-6789\n");
  print &$digit_tr("FAX ：0124-51-5368\n");

  # output:
  # 電話：〇一二四－四五－六七八九
  # FAX ：〇一二四－五一－五三六八

The functionality of the closure made by C<trclosure()> is equivalent 
to that of C<strtr()>. Frankly speaking, the C<strtr()> calls
C<trclosure()> internally and uses the returned closure.

=back

=head2 Conversion between hiragana and katakana

=over 4

=item C<kanaH2Z(STRING)>

Converts Hankaku Katakana to Zenkaku Katakana

=item C<kataZ2H(STRING)>

Converts Zenkaku Katakana to Hankaku Katakana

=item C<kanaZ2H(STRING)>

Converts Zenkaku Hiragana and Katakana to Hankaku Katakana

=item C<hiXka(STRING)>

Converts Zenkaku Hiragana to Zenkaku Katakana
and Zenkaku Katakana to Zenkaku Hiragana at once.

=item C<hi2ka(STRING)>

Converts Zenkaku Hiragana to Zenkaku Katakana

=item C<ka2hi(STRING)>

Converts Zenkaku Katakana to Zenkaku Hiragana

=back

=head2 Conversion of Whitespace Characters

=over 4

=item C<spaceH2Z(STRING)>

Converts space (half-width) to ideographic space (full-width)
in the specified string and returns the converted string.

=item C<spaceZ2H(STRING)>

Converts ideographic space (full-width) to space (half-width)
in the specified string and returns the converted string.

=back

=head1 CAVEAT

A legal Shift_JIS character in this module
must match the following regexp:

   [\x00-\x7F\xA1-\xDF]|[\x81-\x9F\xE0-\xFC][\x40-\x7E\x80-\xFC]

Any string from external source should be checked by C<issjis()>
function, excepting you know it is surely encoded in Shift_JIS.
If an illegal Shift_JIS string is specified,
the result should be unexpectable.

Some Shift_JIS double-byte character have one of C<[\x40-\x7E]>
as the trail byte.

   @ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~

Perl lexer doesn't take any care to these characters,
so they sometimes make trouble.
e.g. the quoted literal C<"表"> cause fatal error,
since its trail byte C<0x5C> escapes the closing quote.

Such a problem doesn't arise when the string is gotten from
any external resource. 
But writing the script containing the Shift_JIS
double-byte character needs the greatest care.

The use of single-quoted heredoc C<E<lt>E<lt> ''>
or C<\xhh> meta characters is recommended
in order to define a Shift_JIS string literal.

The safe ASCII-graphic characters, C<[\x21-\x3F]>, are:

   !"#$%&'()*+,-./0123456789:;<=>?

They are preferred as the delimiter of quote-like operators.

=head1 BUGS

This library supposes C<$[> is always equal to 0, never 1. 

The functions provided by this library use B<many> regexp operations.
Therefore, C<$1> etc. values may be changed or discarded unexpectedly.
I suggest you save it in a certain variable 
before call of the function.

=head1 AUTHOR

Tomoyuki SADAHIRO

  bqw10602@nifty.com
  http://homepage1.nifty.com/nomenclator/perl/

  This program is free software; you can redistribute it and/or 
  modify it under the same terms as Perl itself.

=head1 SEE ALSO

perl(1)

=cut
