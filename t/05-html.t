#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 8;
use Data::Dumper;

use Spreadsheet::HTML;

my $data = [
    [qw(header1 header2 header3 header4 )],
    [qw(foo1 bar1 baz1 qux1)],
    [qw(foo2 bar2 baz2 qux2)],
    [qw(foo3 bar3 baz3 qux3)],
    [qw(foo4 bar4 baz4 qux4)],
];
my $with_th = '<table><tr><th>header1</th><th>header2</th><th>header3</th><th>header4</th></tr><tr><td>foo1</td><td>bar1</td><td>baz1</td><td>qux1</td></tr><tr><td>foo2</td><td>bar2</td><td>baz2</td><td>qux2</td></tr><tr><td>foo3</td><td>bar3</td><td>baz3</td><td>qux3</td></tr><tr><td>foo4</td><td>bar4</td><td>baz4</td><td>qux4</td></tr></table>';

my $table = Spreadsheet::HTML->new( data => $data );

is $table->generate, $with_th,                                  "correct HTML from method call" ;
is Spreadsheet::HTML::generate( $data ), $with_th,              "correct HTML from procedural call (array ref arg)" ;
is Spreadsheet::HTML::generate( @$data ), $with_th,             "correct HTML from procedural call (list arg)" ;
is Spreadsheet::HTML::generate( data => $data ), $with_th,      "correct HTML from procedural call (named params)" ;

my $no_th = '<table><tr><td>header1</td><td>header2</td><td>header3</td><td>header4</td></tr><tr><td>foo1</td><td>bar1</td><td>baz1</td><td>qux1</td></tr><tr><td>foo2</td><td>bar2</td><td>baz2</td><td>qux2</td></tr><tr><td>foo3</td><td>bar3</td><td>baz3</td><td>qux3</td></tr><tr><td>foo4</td><td>bar4</td><td>baz4</td><td>qux4</td></tr></table>';

is $table->generate( matrix => 1 ), $no_th,                                "only <td> tags via method args" ;
is Spreadsheet::HTML::generate( data => $data, matrix => 1 ), $no_th,      "only <td> tags via procedural named args" ;

$table = Spreadsheet::HTML->new( data => $data, matrix => 1 );
is $table->generate, $no_th,                                                "only <td> tags via constructor args" ;
is $table->generate( matrix => 0 ), $with_th,                              "<th> tags are back via method args" ;
