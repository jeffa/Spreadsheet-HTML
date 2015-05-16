#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 4;
use Data::Dumper;

use Spreadsheet::HTML;

my $data = [
    [qw(header1 header2 header3 header4 )],
    [qw(foo1 bar1 baz1 qux1)],
    [qw(foo2 bar2 baz2 qux2)],
    [qw(foo3 bar3 baz3 qux3)],
    [qw(foo4 bar4 baz4 qux4)],
];
my $expected = '<table><tr><th>header1</th><td>foo1</td><td>foo2</td><td>foo3</td><td>foo4</td></tr><tr><th>header2</th><td>bar1</td><td>bar2</td><td>bar3</td><td>bar4</td></tr><tr><th>header3</th><td>baz1</td><td>baz2</td><td>baz3</td><td>baz4</td></tr><tr><th>header4</th><td>qux1</td><td>qux2</td><td>qux3</td><td>qux4</td></tr></table>';

my $table = new_ok 'Spreadsheet::HTML', [ data => $data ];

is $table->transpose, $expected,                         "correct HTML from method call" ;
is Spreadsheet::HTML::transpose( $data ), $expected,     "correct HTML from procedural call (array ref arg)" ;
is Spreadsheet::HTML::transpose( @$data ), $expected,    "correct HTML from procedural call (list arg)" ;
