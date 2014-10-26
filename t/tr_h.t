# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

BEGIN { $| = 1; print "1..15\n"; }
END {print "not ok 1\n" unless $loaded;}

use ShiftJIS::String qw(strtr);

$^W = 1;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

%hash = strtr(
    '����������@���͂ɂ��݂���@���݂̂���',
    "��-����-��", "", "h");
$join = join ':', map "$_=>$hash{$_}", sort keys %hash;

print $join eq '��=>2:��=>1:��=>1:��=>1:��=>1:��=>1'
    ? "ok" : "not ok", " 2\n";

$hash = strtr(
    '����������@���͂ɂ��݂���@���݂̂���',
    "��-����-��", "", "h");
$join = join ':', map "$_=>$$hash{$_}", sort keys %$hash;

print $join eq '��=>2:��=>1:��=>1:��=>1:��=>1:��=>1'
    ? "ok" : "not ok", " 3\n";

%hash = strtr(
    "Caesar Aether Goethe Europaeae Oestrone Uenoeki",
    "aeoeueAeOeUe",
    "&auml;&ouml;&ouml;&Auml;&Ouml;&Uuml;",
    "h",
    "[aouAOU]e",
    "&[aouAOU]uml;");
$join = join ':', map "$_=>$hash{$_}", sort keys %hash;

print $join eq "Ae=>1:Oe=>1:Ue=>1:ae=>3:oe=>2"
    ? "ok" : "not ok", " 4\n";

%hash = strtr('���{��̃J�^�J�i', '��-��@-���-�', '', 'h');
$join = join ':', map "$_=>$hash{$_}", sort keys %hash;

print $join eq '��=>1:�J=>2:�^=>1:�i=>1'
    ? "ok" : "not ok", " 5\n";

$str = '���{��̃J�^�J�i';
%hash = strtr(\$str, '��-��@-��', '�@-����-��', 'h');
$join = join ':', map "$_=>$hash{$_}", sort keys %hash;

print $join eq '��=>1:�J=>2:�^=>1:�i=>1'
    ? "ok" : "not ok", " 6\n";
print $str eq '���{��m��������'
    ? "ok" : "not ok", " 7\n";

$str = '���{��̃J�^�J�i�̖{';
%hash = strtr(\$str, '��-��@-��', '', 'cdh');
$join = join ':', map "$_=>$hash{$_}", sort keys %hash;

print $join eq '��=>1:��=>1:�{=>2'
    ? "ok" : "not ok", " 8\n";
print $str eq '�̃J�^�J�i��'
    ? "ok" : "not ok", " 9\n";

$str = '���{��̃J�^�J�i�̖{';
%hash = strtr(\$str, '��-��@-��', '', 'dh');
$join = join ':', map "$_=>$hash{$_}", sort keys %hash;

print $join eq '��=>2:�J=>2:�^=>1:�i=>1'
    ? "ok" : "not ok", " 10\n";
print $str eq '���{��{'
    ? "ok" : "not ok", " 11\n";

$str = '���{��̃J�^�J�i�̖{';
%hash = strtr(\$str, '��-��@-��', '', 'ch');
$join = join ':', map "$_=>$hash{$_}", sort keys %hash;

print $join eq '��=>1:��=>1:�{=>2'
    ? "ok" : "not ok", " 12\n";
print $str eq '���{��̃J�^�J�i�̖{'
    ? "ok" : "not ok", " 13\n";

$str = '�{���̓��{��̃J�^�J�i�̖{';
%hash = strtr(\$str, '��-��@-��', '!', 'ch');
$join = join ':', map "$_=>$hash{$_}", sort keys %hash;

print $join eq '��=>1:��=>1:��=>1:�{=>3'
    ? "ok" : "not ok", " 14\n";
print $str eq '!!��!!!�̃J�^�J�i��!'
    ? "ok" : "not ok", " 15\n";

1;
__END__
