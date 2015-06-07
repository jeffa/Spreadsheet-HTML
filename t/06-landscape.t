#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 15;

use Spreadsheet::HTML;

my $data = [
    [qw(header1 header2 header3 header4 )],
    [qw(foo1 bar1 baz1 qux1)],
    [qw(foo2 bar2 baz2 qux2)],
    [qw(foo3 bar3 baz3 qux3)],
    [qw(foo4 bar4 baz4 qux4)],
];
my $expected = '<table><tr><th>header1</th><td>foo1</td><td>foo2</td><td>foo3</td><td>foo4</td></tr><tr><th>header2</th><td>bar1</td><td>bar2</td><td>bar3</td><td>bar4</td></tr><tr><th>header3</th><td>baz1</td><td>baz2</td><td>baz3</td><td>baz4</td></tr><tr><th>header4</th><td>qux1</td><td>qux2</td><td>qux3</td><td>qux4</td></tr></table>';

my $table = Spreadsheet::HTML->new( data => $data );
is $table->landscape, $expected,                         "correct HTML from method call" ;
is Spreadsheet::HTML::landscape( $data ), $expected,     "correct HTML from procedural call (array ref arg)" ;
is Spreadsheet::HTML::landscape( @$data ), $expected,    "correct HTML from procedural call (list arg)" ;

is Spreadsheet::HTML::landscape( data => $data, matrix => 1 ), 
    '<table><tr><td>header1</td><td>foo1</td><td>foo2</td><td>foo3</td><td>foo4</td></tr><tr><td>header2</td><td>bar1</td><td>bar2</td><td>bar3</td><td>bar4</td></tr><tr><td>header3</td><td>baz1</td><td>baz2</td><td>baz3</td><td>baz4</td></tr><tr><td>header4</td><td>qux1</td><td>qux2</td><td>qux3</td><td>qux4</td></tr></table>',
   "correct HTML from procedural call (list arg)";

is Spreadsheet::HTML::landscape( data => $data, headless => 1 ), 
    '<table><tr><td>foo1</td><td>foo2</td><td>foo3</td><td>foo4</td></tr><tr><td>bar1</td><td>bar2</td><td>bar3</td><td>bar4</td></tr><tr><td>baz1</td><td>baz2</td><td>baz3</td><td>baz4</td></tr><tr><td>qux1</td><td>qux2</td><td>qux3</td><td>qux4</td></tr></table>',
   "correct HTML from procedural call (list arg)";


$expected = '<table><tr><td>foo4</td><td>foo3</td><td>foo2</td><td>foo1</td><th>header1</th></tr><tr><td>bar4</td><td>bar3</td><td>bar2</td><td>bar1</td><th>header2</th></tr><tr><td>baz4</td><td>baz3</td><td>baz2</td><td>baz1</td><th>header3</th></tr><tr><td>qux4</td><td>qux3</td><td>qux2</td><td>qux1</td><th>header4</th></tr></table>';
is $table->earthquake, $expected,                         "earthquake: correct HTML from method call" ;
is Spreadsheet::HTML::earthquake( $data ), $expected,     "earthquake: correct HTML from procedural call (array ref arg)" ;
is Spreadsheet::HTML::earthquake( @$data ), $expected,    "earthquake: correct HTML from procedural call (list arg)" ;

is Spreadsheet::HTML::earthquake( data => $data, matrix => 1 ), 
    '<table><tr><td>foo4</td><td>foo3</td><td>foo2</td><td>foo1</td><td>header1</td></tr><tr><td>bar4</td><td>bar3</td><td>bar2</td><td>bar1</td><td>header2</td></tr><tr><td>baz4</td><td>baz3</td><td>baz2</td><td>baz1</td><td>header3</td></tr><tr><td>qux4</td><td>qux3</td><td>qux2</td><td>qux1</td><td>header4</td></tr></table>',
   "earthquake: correct HTML from procedural call (list arg)";

is Spreadsheet::HTML::earthquake( data => $data, headless => 1 ), 
    '<table><tr><td>foo4</td><td>foo3</td><td>foo2</td><td>foo1</td></tr><tr><td>bar4</td><td>bar3</td><td>bar2</td><td>bar1</td></tr><tr><td>baz4</td><td>baz3</td><td>baz2</td><td>baz1</td></tr><tr><td>qux4</td><td>qux3</td><td>qux2</td><td>qux1</td></tr></table>',
   "earthquake: correct HTML from procedural call (list arg)";


$expected = '<table><tr><td>qux4</td><td>qux3</td><td>qux2</td><td>qux1</td><th>header4</th></tr><tr><td>baz4</td><td>baz3</td><td>baz2</td><td>baz1</td><th>header3</th></tr><tr><td>bar4</td><td>bar3</td><td>bar2</td><td>bar1</td><th>header2</th></tr><tr><td>foo4</td><td>foo3</td><td>foo2</td><td>foo1</td><th>header1</th></tr></table>';
is $table->tsunami, $expected,                         "tsunami: correct HTML from method call" ;
is Spreadsheet::HTML::tsunami( $data ), $expected,     "tsunami: correct HTML from procedural call (array ref arg)" ;
is Spreadsheet::HTML::tsunami( @$data ), $expected,    "tsunami: correct HTML from procedural call (list arg)" ;

is Spreadsheet::HTML::tsunami( data => $data, matrix => 1 ), 
    '<table><tr><td>qux4</td><td>qux3</td><td>qux2</td><td>qux1</td><td>header4</td></tr><tr><td>baz4</td><td>baz3</td><td>baz2</td><td>baz1</td><td>header3</td></tr><tr><td>bar4</td><td>bar3</td><td>bar2</td><td>bar1</td><td>header2</td></tr><tr><td>foo4</td><td>foo3</td><td>foo2</td><td>foo1</td><td>header1</td></tr></table>',
   "tsunami: correct HTML from procedural call (list arg)";

is Spreadsheet::HTML::tsunami( data => $data, headless => 1 ), 
    '<table><tr><td>qux4</td><td>qux3</td><td>qux2</td><td>qux1</td></tr><tr><td>baz4</td><td>baz3</td><td>baz2</td><td>baz1</td></tr><tr><td>bar4</td><td>bar3</td><td>bar2</td><td>bar1</td></tr><tr><td>foo4</td><td>foo3</td><td>foo2</td><td>foo1</td></tr></table>',
   "tsunami: correct HTML from procedural call (list arg)";