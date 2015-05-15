#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 2;

my $local_version = version_from_file( 'lib/Spreadsheet/HTML.pm' );

use_ok( 'Spreadsheet::HTML', $local_version ) or print "Bail out!\n";

is $Spreadsheet::HTML::VERSION, $local_version, "correct version ($local_version)";

sub version_from_file {
    my $file = shift;
    open FH, $file;
    my ($version) = map {/'([0-9.]+)'/;$1} grep /our\s+\$VERSION/, <FH>;
    close FH;
    return $version;
}

