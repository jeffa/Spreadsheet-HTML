#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Spreadsheet::HTML' ) || print "Bail out!\n";
}

diag( "Testing Spreadsheet::HTML $Spreadsheet::HTML::VERSION, Perl $], $^X" );
