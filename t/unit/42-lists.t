#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 17;

eval "use Spreadsheet::Read";
eval "use Text::CSV";
eval "use Text::CSV_XS";
eval "use Text::CSV_PP";
plan skip_all => "Spreadsheet::Read and Text::CSV, Text::CSV_XS or Text::CSV_PP required" if $@;

use Spreadsheet::HTML;

my $generator = Spreadsheet::HTML->new( sorted_attrs => 1 );

my %by_row = ( file => 't/data/list-byrow.csv' );
my %by_col = ( file => 't/data/list-bycol.csv' );

is $generator->list( %by_col ),
    '<ul><li>id1</li><li>id2</li><li>id3</li><li>id4</li><li>id5</li></ul>',
    "default list() args expect columns"
;

is $generator->list( %by_col, headless => 1 ),
    '<ul><li>id2</li><li>id3</li><li>id4</li><li>id5</li></ul>',
    "list() headless removes 1st element"
;

is $generator->list( %by_col, ordered => 1 ),
    '<ol><li>id1</li><li>id2</li><li>id3</li><li>id4</li><li>id5</li></ol>',
    "list() ordered param emits <ol> instead of <ul>"
;

is $generator->list( %by_col, col => 1 ),
    '<ul><li>lb1</li><li>lb2</li><li>lb3</li><li>lb4</li><li>lb5</li></ul>',
    "list() specific col param works"
;

is $generator->list( %by_row, row => 0 ),
    '<ul><li>id1</li><li>id2</li><li>id3</li><li>id4</li><li>id5</li></ul>',
    "list() row instead of column"
;

is $generator->list( %by_row, , row => 0, ordered => 1 ),
    '<ol><li>id1</li><li>id2</li><li>id3</li><li>id4</li><li>id5</li></ol>',
    "list() ordered param emits <ol> instead of <ul>"
;

is $generator->list( %by_row, row => 1 ),
    '<ul><li>lb1</li><li>lb2</li><li>lb3</li><li>lb4</li><li>lb5</li></ul>',
    "list() specific row param works"
;

is $generator->list( %by_col, ul => { class => "list" } ),
    '<ul class="list"><li>id1</li><li>id2</li><li>id3</li><li>id4</li><li>id5</li></ul>',
    "list() ul param works"
;

is $generator->list( %by_col, ordered => 1, ol => { class => "list" } ),
    '<ol class="list"><li>id1</li><li>id2</li><li>id3</li><li>id4</li><li>id5</li></ol>',
    "list() ol param works"
;

is $generator->list( %by_col, ol => { class => "list" } ),
    '<ul class="list"><li>id1</li><li>id2</li><li>id3</li><li>id4</li><li>id5</li></ul>',
    "list() ul and ol param interchangeable"
;

is $generator->list( %by_col, li => { class => [qw(odd even)] } ),
    '<ul><li class="odd">id1</li><li class="even">id2</li><li class="odd">id3</li><li class="even">id4</li><li class="odd">id5</li></ul>',
    "list() li param works for <ul>"
;

is $generator->list( %by_col, ordered => 1, li => { class => [qw(odd even)] } ),
    '<ol><li class="odd">id1</li><li class="even">id2</li><li class="odd">id3</li><li class="even">id4</li><li class="odd">id5</li></ol>',
    "list() li param as attributes works for <ol>"
;

is $generator->list( %by_col, li => sub { uc shift } ),
    '<ul><li>ID1</li><li>ID2</li><li>ID3</li><li>ID4</li><li>ID5</li></ul>',
    "list() li param as sub ref works for <ol>"
;

is $generator->list( %by_col, ordered => 1, li => [{ class => [qw(odd even)] }, sub { uc shift }] ),
    '<ol><li class="odd">ID1</li><li class="even">ID2</li><li class="odd">ID3</li><li class="even">ID4</li><li class="odd">ID5</li></ol>',
    "list() li param as attributes and sub ref works for <ol>"
;

is $generator->list( %by_col, col => 2, encode => 1 ),
    '<ul><li>&lt;extra&gt;</li><li>&lt;extra&gt;</li><li>&lt;extra&gt;</li><li>&lt;extra&gt;</li><li>&lt;extra&gt;</li></ul>',
    "list() default encoding works"
;

is $generator->list( %by_col, col => 1, encodes => 'lb' ),
    '<ul><li>&#108;&#98;1</li><li>&#108;&#98;2</li><li>&#108;&#98;3</li><li>&#108;&#98;4</li><li>&#108;&#98;5</li></ul>',
    "list() specific encoding works"
;

is $generator->generate( %by_col ),
    '<table><tr><th>id1</th><th>lb1</th><th><extra></th><th>extra</th></tr><tr><td>id2</td><td>lb2</td><td><extra></td><td>extra</td></tr><tr><td>id3</td><td>lb3</td><td><extra></td><td>extra</td></tr><tr><td>id4</td><td>lb4</td><td><extra></td><td>extra</td></tr><tr><td>id5</td><td>lb5</td><td><extra></td><td>extra</td></tr></table>',
    "list() encoding does not persist"
;
