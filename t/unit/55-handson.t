#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 2;

use Spreadsheet::HTML;

my %args = ( sorted_attrs => 1, fill => '2x2' );
my $generator = Spreadsheet::HTML->new( %args );

my $html = '<div id="handsontable"><table class="handsontable"><tr><th></th><th></th></tr><tr><td></td><td></td></tr></table></div>';

is scrub( $generator->handson() ),
    $html,
    "handson as method correct";

is scrub( Spreadsheet::HTML::handson( %args ) ),
    $html,
    "handson as function correct";

sub scrub {
    $_[0] =~ s/.*?<div/<div/s;
    return $_[0];
}
