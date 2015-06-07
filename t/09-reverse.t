#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 5;

use Spreadsheet::HTML;

my $data = [
    [qw(header1 header2 header3 header4 )],
    [qw(foo1 bar1 baz1 qux1)],
    [qw(foo2 bar2 baz2 qux2)],
    [qw(foo3 bar3 baz3 qux3)],
    [qw(foo4 bar4 baz4 qux4)],
];
my $expected = '<table><tr><td>foo4</td><td>bar4</td><td>baz4</td><td>qux4</td></tr><tr><td>foo3</td><td>bar3</td><td>baz3</td><td>qux3</td></tr><tr><td>foo2</td><td>bar2</td><td>baz2</td><td>qux2</td></tr><tr><td>foo1</td><td>bar1</td><td>baz1</td><td>qux1</td></tr><tr><th>header1</th><th>header2</th><th>header3</th><th>header4</th></tr></table>';

my $table = Spreadsheet::HTML->new( data => $data );
is $table->reverse, $expected,                         "correct HTML from method call" ;
is Spreadsheet::HTML::reverse( $data ), $expected,     "correct HTML from procedural call (array ref arg)" ;
is Spreadsheet::HTML::reverse( @$data ), $expected,    "correct HTML from procedural call (list arg)" ;


is Spreadsheet::HTML::reverse( data => $data, matrix => 1 ), 
    '<table><tr><td>foo4</td><td>bar4</td><td>baz4</td><td>qux4</td></tr><tr><td>foo3</td><td>bar3</td><td>baz3</td><td>qux3</td></tr><tr><td>foo2</td><td>bar2</td><td>baz2</td><td>qux2</td></tr><tr><td>foo1</td><td>bar1</td><td>baz1</td><td>qux1</td></tr><tr><td>header1</td><td>header2</td><td>header3</td><td>header4</td></tr></table>',
   "correct HTML from procedural call (list arg)" 
;

is Spreadsheet::HTML::reverse( data => $data, headless => 1 ), 
    '<table><tr><td>foo4</td><td>bar4</td><td>baz4</td><td>qux4</td></tr><tr><td>foo3</td><td>bar3</td><td>baz3</td><td>qux3</td></tr><tr><td>foo2</td><td>bar2</td><td>baz2</td><td>qux2</td></tr><tr><td>foo1</td><td>bar1</td><td>baz1</td><td>qux1</td></tr></table>',
   "correct HTML from procedural call (list arg)" 
;
