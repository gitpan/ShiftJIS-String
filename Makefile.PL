use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

# This code for  XS-NOXS installer is shamelessly stolen
# from Gurusamy Sarathy's Data::Dumper. Thank you!

# a bit modified.

use File::Copy qw();

my $arg = $ARGV[0] || "";

if ($arg =~ /^no/i and -f "String.xs") {
    print STDERR "Disabling XS in sources...\n";

    die "***** Failed, sources could be inconsistent! *****\n"
     unless File::Copy::move('MANIFEST',	'MANIFEST.XS')
	and File::Copy::move('MANIFEST.NXS',	'MANIFEST')
	and File::Copy::move('String.pm',	'String.pm.XS')
	and File::Copy::move('String.xs',	'String.xs.XS')
	and File::Copy::move('String.pm.NXS',	'String.pm');
}
if ($arg =~ /^xs/i and -f "String.xs.XS") {
    print STDERR "Enabling XS in sources...\n";

    die "***** Failed, sources could be inconsistent! *****\n"
     unless File::Copy::move('MANIFEST',	'MANIFEST.NXS')
	and File::Copy::move('MANIFEST.XS',	'MANIFEST')
	and File::Copy::move('String.pm',	'String.pm.NXS')
	and File::Copy::move('String.xs.XS',	'String.xs')
	and File::Copy::move('String.pm.XS',	'String.pm');
}

WriteMakefile(
    'NAME'	=> 'ShiftJIS::String',
    'VERSION_FROM' => 'String.pm', # finds $VERSION
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM => 'String.pod', # retrieve abstract from module
       AUTHOR     => 'SADAHIRO Tomoyuki <SADAHIRO@cpan.org>') : ()),
);
