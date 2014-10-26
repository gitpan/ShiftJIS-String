# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

BEGIN { $| = 1; print "1..18\n"; }
END {print "not ok 1\n" unless $loaded;}
use ShiftJIS::String qw(mkrange trclosure strsplit);
$^W = 1;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

sub listtostr {
  my @a = @_;
  return @a ? join('', map "<$_>", @a) : '';
}

{
  my $printZ2H = trclosure(
    '�O-�X�`-�y��-���@�^���{�|�D�C�F�G�H�I�����������������i�j�m�n�o�p',
    '0-9A-Za-z /=+\-.,:;?!#$%&@*<>()[]{}',
  );

  my $str = '  This  is   a  TEST =@ ';
  my $zen = '�@ T��i���@ is�@ �@a  �s�dST�@��@ ';

  my($n, $NG);

# splitchar in scalar context
  $NG = 0;
  for $n (-1..20){
    my $core = @{[ split(//, $str, $n) ]};
    my $sjis = strsplit('',$zen,$n);
    ++$NG unless $core == $sjis;
  }
  print !$NG ? "ok" : "not ok", " 2\n";

# splitchar in list context
  $NG = 0;
  for $n (-1..20){
    my $core = listtostr( split //, $str, $n );
    my $sjis = listtostr( strsplit('',$zen,$n) );
    ++$NG unless $core eq &$printZ2H($sjis);
  }
  print !$NG ? "ok" : "not ok", " 3\n";

# splitspace in scalar context
  $NG = 0;
  for $n (-1..5){
    my $core = @{[ split ' ', $str, $n ]};
    my $sjis = strsplit(undef,$zen,$n);
    ++$NG unless $core eq &$printZ2H($sjis);
  }
  print !$NG ? "ok" : "not ok", " 4\n";

# splitspace in list context
  $NG = 0;
  for $n (-1..5){
    my $core = listtostr( split(' ', $str, $n) );
    my $sjis = listtostr( strsplit(undef,$zen,$n) );
    ++$NG unless $core eq &$printZ2H($sjis);
  }
  print !$NG ? "ok" : "not ok", " 5\n";

# split / / in scalar context
  $NG = 0;
  for $n (-1..5){
    my $core = @{ [ split(/ /, $str, $n) ] };
    my $sjis = strsplit(' ',$str,$n);
    ++$NG unless $core == $sjis;
  }
  print !$NG ? "ok" : "not ok", " 6\n";

# split / / in list context
  $NG = 0;
  for $n (-1..5){
    my $core = listtostr( split(/ /, $str, $n) );
    my $sjis = listtostr( strsplit(' ',$str,$n) );
    ++$NG unless $core eq &$printZ2H($sjis);
  }
  print !$NG ? "ok" : "not ok", " 7\n";

# splitchar '' in scalar context
  $NG = 0;
  for $n (-1..20){
    my $core = @{[ split(//, '', $n) ]};
    my $sjis = strsplit('','',$n);
    ++$NG unless $core == $sjis;
  }
  print !$NG ? "ok" : "not ok", " 8\n";

# splitchar '' in list context
  $NG = 0;
  for $n (-1..20){
    my $core = listtostr split //, '', $n;
    my $sjis = listtostr strsplit '','',$n;
    ++$NG unless $core eq $sjis;
  }
  print !$NG ? "ok" : "not ok", " 9\n";

# splitspace '' in scalar context
  $NG = 0;
  for $n (-1..20){
    my $core = @{[ split(' ', '', $n) ]};
    my $sjis = strsplit(undef,'',$n);
    ++$NG unless $core == $sjis;
  }
  print !$NG ? "ok" : "not ok", " 10\n";

# splitspace '' in list context
  $NG = 0;
  for $n (-1..20){
    my $core = listtostr split ' ', '', $n;
    my $sjis = listtostr strsplit undef,'',$n;
    ++$NG unless $core eq $sjis;
  }
  print !$NG ? "ok" : "not ok", " 11\n";

# split / /, '' in scalar context
  $NG = 0;
  for $n (-1..5){
    my $core = @{ [ split(/ /, '', $n) ] };
    my $sjis = strsplit(' ', '', $n);
    ++$NG unless $core == $sjis;
  }
  print !$NG ? "ok" : "not ok", " 12\n";

# split / /, '' in list context
  $NG = 0;
  for $n (-1..5){
    my $core = listtostr split / /, '', $n;
    my $sjis = listtostr strsplit ' ', '', $n;
    ++$NG unless $core eq $sjis;
  }
  print !$NG ? "ok" : "not ok", " 13\n";

# end by non-SPACE
  $str = "\t\n\r\f\n".'  This  is   a  TEST =@';
  $zen = "\t\n\r\f\n".'�@ T��i���@ is�@ �@a  �s�dST�@��@';

# splitspace in scalar context
  $NG = 0;
  for $n (-1..5){
    my $core = @{[ split ' ', $str, $n ]};
    my $sjis = strsplit(undef,$zen,$n);
    ++$NG unless $core eq &$printZ2H($sjis);
  }
  print !$NG ? "ok" : "not ok", " 14\n";

# splitspace in list context
  $NG = 0;
  for $n (-1..5){
    my $core = listtostr( split(' ', $str, $n) );
    my $sjis = listtostr( strsplit(undef,$zen,$n) );
    ++$NG unless $core eq &$printZ2H($sjis);
  }
  print !$NG ? "ok" : "not ok", " 15\n";
}


print 1
  && 'Perl:�p�k:Camel' eq join(":", strsplit('�^', 'Perl�^�p�k�^Camel'))
  && '��:����:������^' eq join(':', strsplit('�^', '���^�����^������^'))
  && join(':', strsplit(undef, '�@�@�@��  ������@�@�����@��^', 3))
     eq '��:������@:�����@��^'
  && join(':', strsplit undef, ' �@ This  is �@ Perl.')
     eq 'This:is:Perl.'
  && join('-;-', strsplit('|', '���Ƀ|�}�[�h�G�L��|�|�|��||�� �A�|��'))
     eq '���Ƀ|�}�[�h�G�L��-;-�|�|��-;--;-�� �A�|��'
  && join('/', strsplit('��', '��������������������'))
     eq '������/��������/��'
  && join('/', strsplit '�|�|', '�|�p�|�s�����|�|�||�����||�|�|�J��|��', 4)
     eq '�|�p�|�s����/�||�����||/�J��|��'
  && join('/', strsplit('||', '����������||�p�s�v�y�|||01234||', -5))
     eq '����������/�p�s�v�y�|/01234/'
  && join('/', strsplit('||', '����������||�p�s�v�y�|||01234||'))
     eq '����������/�p�s�v�y�|/01234'
  && join('/', strsplit('||', '����������||�p�s�v�y�|||01234||', 2))
     eq '����������/�p�s�v�y�|||01234||'
  && join('/', strsplit('||', '||����������||�p�s�v�y�|||01234||||'))
     eq '/����������/�p�s�v�y�|/01234'
  && join('/', strsplit('||', '||����������||�p�s�v�y�|||01234||||', -10))
     eq '/����������/�p�s�v�y�|/01234//'
  && join('-:-', strsplit('�^', 'Perl�^�v���O�����^�p�X���[�h'))
     eq 'Perl-:-�v���O����-:-�p�X���[�h'
  ? "ok" : "not ok", " 16\n";


{
  my($n, $NG, $ary);
  for $ary (
    ["AA", "AAAA", 3 ],
    ["AA", "AAAA", 0 ],
    ["AA", "AAAA", -1 ],
    ["AA", "AA", 3 ],
    ["AA", "AA", 0 ],
    ["AA", "AA", -1 ],
    ["AB", "AB", 3 ],
    ["AB", "AB", 0 ],
    ["AB", "AB", -1 ],
    ["AB", "AC", 3 ],
    ["AB", "AC", 0 ],
    ["AB", "AC", -1 ],
    ["AA", "AAAAAAAAA", 3 ],
    ["AA", "AAAAAAAAA", 0 ],
    ["AA", "AAAAAAAAA", -1 ],
    ["AA", "AAAAAAAAAA", 3 ],
    ["AA", "AAAAAAAAAA", 0 ],
    ["AA", "AAAAAAAAAA", -1 ],
    ["AA", "AAABBAABBAA", 4 ],
    ["AA", "AAABBAABBAAAA", 7 ],
  )
  {
     my $core_s = @{[ split($ary->[0], $ary->[1], $ary->[2]) ]};
     my $sjis_s = strsplit($ary->[0], $ary->[1], $ary->[2]);
     my $core_l = listtostr split($ary->[0], $ary->[1], $ary->[2]);
     my $sjis_l = listtostr strsplit($ary->[0], $ary->[1], $ary->[2]);
     ++$NG unless $core_s == $sjis_s && $core_l eq $sjis_l;
  }
  print !$NG ? "ok" : "not ok", " 17\n";
}

print 1
  && 'Perl:�p�k:Camel' eq join(":", strsplit(undef, 'Perl�@�p�k�@Camel'))
  && 'Perl:�p�k�@Camel' eq join(":", strsplit(undef, 'Perl�@�p�k�@Camel',2))
  && 'Perl:�p�k:Camel' eq join(":", strsplit(undef, 'Perl�@�p�k�@Camel�@'))
  && 'Perl:�p�k:Camel:' eq join(":", strsplit(undef, 'Perl�@�p�k�@Camel�@',-2))
  ? "ok" : "not ok", " 18\n";
