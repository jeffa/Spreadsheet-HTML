#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 26;

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
is Spreadsheet::HTML::generate( $data, foo => 'bar' ), $with_th,              "extra params does not break procedural call (array ref arg)" ;
is Spreadsheet::HTML::generate( @$data, foo => 'bar' ), $with_th,             "extra params does not break procedural call (list arg)" ;
is Spreadsheet::HTML::generate( data => $data, foo => 'bar' ), $with_th,      "extra params does not break procedural call (named params)" ;

my $no_th = '<table><tr><td>header1</td><td>header2</td><td>header3</td><td>header4</td></tr><tr><td>foo1</td><td>bar1</td><td>baz1</td><td>qux1</td></tr><tr><td>foo2</td><td>bar2</td><td>baz2</td><td>qux2</td></tr><tr><td>foo3</td><td>bar3</td><td>baz3</td><td>qux3</td></tr><tr><td>foo4</td><td>bar4</td><td>baz4</td><td>qux4</td></tr></table>';

is $table->generate( matrix => 1 ), $no_th,                                "only <td> tags via method args" ;
is Spreadsheet::HTML::generate( data => $data, matrix => 1 ), $no_th,      "only <td> tags via procedural named args" ;

$table = Spreadsheet::HTML->new( data => $data, matrix => 1 );
is $table->generate, $no_th,                                                "only <td> tags via constructor args" ;
is $table->generate( matrix => 0 ), $with_th,                              "<th> tags are back via method args" ;

my $no_head = '<table><tr><td>foo1</td><td>bar1</td><td>baz1</td><td>qux1</td></tr><tr><td>foo2</td><td>bar2</td><td>baz2</td><td>qux2</td></tr><tr><td>foo3</td><td>bar3</td><td>baz3</td><td>qux3</td></tr><tr><td>foo4</td><td>bar4</td><td>baz4</td><td>qux4</td></tr></table>';

$table = Spreadsheet::HTML->new( data => $data, headless => 1 );
is $table->generate, $no_head,                                              "no headings (via constructore)" ;
is $table->generate( headless => 0 ), $with_th,                             "headings are back (via named args)" ;
is $table->generate( headless => 1 ), $no_head,                             "headings are gone again (via named args)" ;
is $table->generate( headless => 0, matrix => 1 ), $no_th,                  "headings are back, matrix style" ;
is Spreadsheet::HTML::generate( data => $data, headless => 1 ), $no_head,   "no headings (procedural nameds args)" ;



my %attrs = (
    table => { class => 'spreadsheet' },
    tr    => { style => 'background: red' },
    th    => { class => 'headings' },
    td    => { class => 'row' },
);
$table = Spreadsheet::HTML->new( data => $data, %attrs );

$with_th = '<table class="spreadsheet"><tr style="background: red"><th class="headings">header1</th><th class="headings">header2</th><th class="headings">header3</th><th class="headings">header4</th></tr><tr style="background: red"><td class="row">foo1</td><td class="row">bar1</td><td class="row">baz1</td><td class="row">qux1</td></tr><tr style="background: red"><td class="row">foo2</td><td class="row">bar2</td><td class="row">baz2</td><td class="row">qux2</td></tr><tr style="background: red"><td class="row">foo3</td><td class="row">bar3</td><td class="row">baz3</td><td class="row">qux3</td></tr><tr style="background: red"><td class="row">foo4</td><td class="row">bar4</td><td class="row">baz4</td><td class="row">qux4</td></tr></table>';
is $table->generate, $with_th,                                                          "correct HTML with tag attributes from method call" ;
is Spreadsheet::HTML::generate( data => $data, %attrs ), $with_th,                      "correct HTML with tag attributes from procedural call (named params)" ;

$no_th = '<table class="spreadsheet"><tr style="background: red"><td class="row">header1</td><td class="row">header2</td><td class="row">header3</td><td class="row">header4</td></tr><tr style="background: red"><td class="row">foo1</td><td class="row">bar1</td><td class="row">baz1</td><td class="row">qux1</td></tr><tr style="background: red"><td class="row">foo2</td><td class="row">bar2</td><td class="row">baz2</td><td class="row">qux2</td></tr><tr style="background: red"><td class="row">foo3</td><td class="row">bar3</td><td class="row">baz3</td><td class="row">qux3</td></tr><tr style="background: red"><td class="row">foo4</td><td class="row">bar4</td><td class="row">baz4</td><td class="row">qux4</td></tr></table>';
is $table->generate( matrix => 1, %attrs ), $no_th,                                     "only <td> tags with attributes via method args" ;
is Spreadsheet::HTML::generate( data => $data, matrix => 1, %attrs ), $no_th,           "only <td> tags with attributes via procedural named args" ;

$no_head = '<table class="spreadsheet"><tr style="background: red"><td class="row">foo1</td><td class="row">bar1</td><td class="row">baz1</td><td class="row">qux1</td></tr><tr style="background: red"><td class="row">foo2</td><td class="row">bar2</td><td class="row">baz2</td><td class="row">qux2</td></tr><tr style="background: red"><td class="row">foo3</td><td class="row">bar3</td><td class="row">baz3</td><td class="row">qux3</td></tr><tr style="background: red"><td class="row">foo4</td><td class="row">bar4</td><td class="row">baz4</td><td class="row">qux4</td></tr></table>';
is $table->generate( headless => 1, %attrs ), $no_head,                                 "no headings for tags with attributes via method args" ;
is Spreadsheet::HTML::generate( data => $data, headless => 1, %attrs ), $no_head,       "no headings for tags with attributes via procedural named args" ;

my $layout = '<table border="0" cellpadding="0" cellspacing="0" role="presentation"><tr><td>&</td></tr><tr><td><</td><td>></td></tr></table>';
$table = Spreadsheet::HTML->new;
is $table->layout( data => [ ['&'],['<','>'] ] ), $layout,                              "correct HTML for layout via method";
is Spreadsheet::HTML::layout( data => [ ['&'],['<','>'] ] ), $layout,                   "correct HTML for layout via procedure";

my $override = '<table><tr><th>&</th></tr><tr><td><</td><td>></td></tr></table>';
$table = Spreadsheet::HTML->new;
is $table->layout( table => undef, encodes => '', matrix => 0, data => [ ['&'],['<','>'] ] ), $override,                        "can override defaults for layout via method";
is Spreadsheet::HTML::layout( table => undef, encodes => '', matrix => 0, data => [ ['&'],['<','>'] ] ), $override,             "can override defaults for layout via method";
