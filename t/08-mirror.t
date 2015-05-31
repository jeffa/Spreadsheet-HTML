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
my $expected = '<table><tr><th>header4</th><th>header3</th><th>header2</th><th>header1</th></tr><tr><td>qux1</td><td>baz1</td><td>bar1</td><td>foo1</td></tr><tr><td>qux2</td><td>baz2</td><td>bar2</td><td>foo2</td></tr><tr><td>qux3</td><td>baz3</td><td>bar3</td><td>foo3</td></tr><tr><td>qux4</td><td>baz4</td><td>bar4</td><td>foo4</td></tr></table>';

my $table = Spreadsheet::HTML->new( data => $data );
is $table->mirror, $expected,                           "correct HTML from method call" ;
is Spreadsheet::HTML::mirror( $data ), $expected,       "correct HTML from procedural call (array ref arg)" ;
is Spreadsheet::HTML::mirror( @$data ), $expected,      "correct HTML from procedural call (list arg)" ;


is Spreadsheet::HTML::mirror( data => $data, matrix => 1 ), 
    '<table><tr><td>header4</td><td>header3</td><td>header2</td><td>header1</td></tr><tr><td>qux1</td><td>baz1</td><td>bar1</td><td>foo1</td></tr><tr><td>qux2</td><td>baz2</td><td>bar2</td><td>foo2</td></tr><tr><td>qux3</td><td>baz3</td><td>bar3</td><td>foo3</td></tr><tr><td>qux4</td><td>baz4</td><td>bar4</td><td>foo4</td></tr></table>',
   "correct HTML from procedural call (list arg)" 
;

is Spreadsheet::HTML::mirror( data => $data, headless => 1 ), 
    '<table><tr><td>qux1</td><td>baz1</td><td>bar1</td><td>foo1</td></tr><tr><td>qux2</td><td>baz2</td><td>bar2</td><td>foo2</td></tr><tr><td>qux3</td><td>baz3</td><td>bar3</td><td>foo3</td></tr><tr><td>qux4</td><td>baz4</td><td>bar4</td><td>foo4</td></tr></table>',
   "correct HTML from procedural call (list arg)" 
;
