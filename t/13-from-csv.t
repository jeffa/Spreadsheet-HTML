#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 4;

use_ok 'Spreadsheet::HTML';

my $table = new_ok 'Spreadsheet::HTML', [ file => 't/data/simple.csv' ];

is $table->generate,
    '<table><tr><th>header1</th><th>header2</th><th>header3</th></tr><tr><td>foo</td><td>bar</td><td>baz</td></tr><tr><td>one</td><td>two</td><td>three</td></tr><tr><td>1</td><td>2</td><td>3</td></tr></table>',
    "loaded simple CSV data"
;

is Spreadsheet::HTML::generate( file => 't/data/simple.csv' ),
    '<table><tr><th>header1</th><th>header2</th><th>header3</th></tr><tr><td>foo</td><td>bar</td><td>baz</td></tr><tr><td>one</td><td>two</td><td>three</td></tr><tr><td>1</td><td>2</td><td>3</td></tr></table>',
    "loaded simple CSV data"
;
