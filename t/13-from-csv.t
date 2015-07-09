#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More;

eval "use Spreadsheet::Read";
plan skip_all => "Spreadsheet::Read required" if $@;

eval "use Text::CSV";
eval "use Text::CSV_XS";
eval "use Text::CSV_PP";
plan skip_all => "Text::CSV, Text::CSV_XS or Text::CSV_PP required" if $@;


plan tests => 6;

use_ok 'Spreadsheet::HTML';

my %file = ( file => 't/data/simple.csv' );

my $table = new_ok 'Spreadsheet::HTML', [ %file ];

is $table->generate,
    '<table><tr><th>header1</th><th>header2</th><th>header3</th></tr><tr><td>foo</td><td>bar</td><td>baz</td></tr><tr><td>one</td><td>two</td><td>three</td></tr><tr><td>1</td><td>2</td><td>3</td></tr></table>',
    "loaded simple CSV data"
;

is Spreadsheet::HTML::generate( %file ),
    '<table><tr><th>header1</th><th>header2</th><th>header3</th></tr><tr><td>foo</td><td>bar</td><td>baz</td></tr><tr><td>one</td><td>two</td><td>three</td></tr><tr><td>1</td><td>2</td><td>3</td></tr></table>',
    "loaded simple CSV data via procedure"
;

$table = Spreadsheet::HTML->new( %file );
is $table->landscape,
    '<table><tr><th>header1</th><td>foo</td><td>one</td><td>1</td></tr><tr><th>header2</th><td>bar</td><td>two</td><td>2</td></tr><tr><th>header3</th><td>baz</td><td>three</td><td>3</td></tr></table>',
    "transposed simple CSV data via method from new object"
;

is Spreadsheet::HTML::landscape( %file ),
    '<table><tr><th>header1</th><td>foo</td><td>one</td><td>1</td></tr><tr><th>header2</th><td>bar</td><td>two</td><td>2</td></tr><tr><th>header3</th><td>baz</td><td>three</td><td>3</td></tr></table>',
    "transposed simple CSV data via procedure"
;
