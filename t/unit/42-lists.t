#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 11;

use Spreadsheet::HTML;

my $generator = Spreadsheet::HTML->new( sorted_attrs => 1 );

my %by_row = ( file => 't/data/list-byrow.csv' );
my %by_col = ( file => 't/data/list-bycol.csv' );

# list

is $generator->list( %by_col ),
    '<ul><li>id1</li><li>id2</li><li>id3</li><li>id4</li><li>id5</li></ul>',
    "default list() args expect columns"
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
    "default list() args works on rows"
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
    "list() li param works for <ol>"
;


# select()
