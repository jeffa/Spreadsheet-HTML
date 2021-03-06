#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 8;

use Spreadsheet::HTML;

my %params = ( sorted_attrs => 1, fill => '2x2' );
my $generator = Spreadsheet::HTML->new( %params );

is $generator->checkerboard(),
    '<table><tr><th style="background-color: red">&nbsp;</th><th style="background-color: green">&nbsp;</th></tr><tr><td style="background-color: green">&nbsp;</td><td style="background-color: red">&nbsp;</td></tr></table>',
    "2x2 checkerboard with default colors as method correct";

is Spreadsheet::HTML::checkerboard( %params ),
    '<table><tr><th style="background-color: red">&nbsp;</th><th style="background-color: green">&nbsp;</th></tr><tr><td style="background-color: green">&nbsp;</td><td style="background-color: red">&nbsp;</td></tr></table>',
    "2x2 checkerboard with default colors as function correct";

is $generator->checkerboard( fill => '2x3' ),
    '<table><tr><th style="background-color: red">&nbsp;</th><th style="background-color: green">&nbsp;</th><th style="background-color: red">&nbsp;</th></tr><tr><td style="background-color: green">&nbsp;</td><td style="background-color: red">&nbsp;</td><td style="background-color: green">&nbsp;</td></tr></table>',
    "2x3 checkerboard with default colors as method correct";

is Spreadsheet::HTML::checkerboard( %params, fill => '2x3' ),
    '<table><tr><th style="background-color: red">&nbsp;</th><th style="background-color: green">&nbsp;</th><th style="background-color: red">&nbsp;</th></tr><tr><td style="background-color: green">&nbsp;</td><td style="background-color: red">&nbsp;</td><td style="background-color: green">&nbsp;</td></tr></table>',
    "2x3 checkerboard with default colors as function correct";

is $generator->checkerboard( fill => '2x3', colors => [qw(red blue green) ] ),
    '<table><tr><th style="background-color: red">&nbsp;</th><th style="background-color: blue">&nbsp;</th><th style="background-color: green">&nbsp;</th></tr><tr><td style="background-color: blue">&nbsp;</td><td style="background-color: green">&nbsp;</td><td style="background-color: red">&nbsp;</td></tr></table>',
    "2x3 checkerboard with custom colors as method correct";

is Spreadsheet::HTML::checkerboard( %params, fill => '2x3', colors => [qw(red blue green) ] ),
    '<table><tr><th style="background-color: red">&nbsp;</th><th style="background-color: blue">&nbsp;</th><th style="background-color: green">&nbsp;</th></tr><tr><td style="background-color: blue">&nbsp;</td><td style="background-color: green">&nbsp;</td><td style="background-color: red">&nbsp;</td></tr></table>',
    "2x3 checkerboard with custom colors as function correct";

is $generator->checkerboard( fill => '3x3', class => [qw(foo bar baz) ] ),
    '<table><tr><th class="foo">&nbsp;</th><th class="bar">&nbsp;</th><th class="baz">&nbsp;</th></tr><tr><td class="bar">&nbsp;</td><td class="baz">&nbsp;</td><td class="foo">&nbsp;</td></tr><tr><td class="baz">&nbsp;</td><td class="foo">&nbsp;</td><td class="bar">&nbsp;</td></tr></table>',
    "3x3 checkerboard with custom colors as method correct";

is Spreadsheet::HTML::checkerboard( %params, fill => '3x3', class => [qw(foo bar baz) ] ),
    '<table><tr><th class="foo">&nbsp;</th><th class="bar">&nbsp;</th><th class="baz">&nbsp;</th></tr><tr><td class="bar">&nbsp;</td><td class="baz">&nbsp;</td><td class="foo">&nbsp;</td></tr><tr><td class="baz">&nbsp;</td><td class="foo">&nbsp;</td><td class="bar">&nbsp;</td></tr></table>',
    "3x3 checkerboard with custom colors as function correct";

