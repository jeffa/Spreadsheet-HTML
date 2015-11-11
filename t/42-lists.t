#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 36;

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

# select()
is $generator->select( %by_col ),
    '<select><option>id1</option><option>id2</option><option>id3</option><option>id4</option><option>id5</option></select>',
    "default select() args expect columns"
;

is $generator->select( %by_col, col => 1 ),
    '<select><option>lb1</option><option>lb2</option><option>lb3</option><option>lb4</option><option>lb5</option></select>',
    "select() specific col param works"
;

is $generator->select( %by_col, label => 'a label' ),
    '<label>a label</label><select><option>id1</option><option>id2</option><option>id3</option><option>id4</option><option>id5</option></select>',
    "select() label param as text"
;

is $generator->select( %by_col, label => { 'a label' => { class => 'label' } } ),
    '<label class="label">a label</label><select><option>id1</option><option>id2</option><option>id3</option><option>id4</option><option>id5</option></select>',
    "select() label param as hash ref"
;

is $generator->select( %by_row, row => 0 ),
    '<select><option>id1</option><option>id2</option><option>id3</option><option>id4</option><option>id5</option></select>',
    "select() row instead of column"
;

is $generator->select( %by_row, row => 1 ),
    '<select><option>lb1</option><option>lb2</option><option>lb3</option><option>lb4</option><option>lb5</option></select>',
    "select() specific row param works"
;

is $generator->select( %by_col, select => { class => 'select' } ),
    '<select class="select"><option>id1</option><option>id2</option><option>id3</option><option>id4</option><option>id5</option></select>',
    "select() attribute works"
;

is $generator->select( %by_col, labels => 1 ),
    '<select><option value="id1">lb1</option><option value="id2">lb2</option><option value="id3">lb3</option><option value="id4">lb4</option><option value="id5">lb5</option></select>',
    "select() labels by default column"
;

is $generator->select( %by_row, row => 0, labels => 1 ),
    '<select><option value="id1">lb1</option><option value="id2">lb2</option><option value="id3">lb3</option><option value="id4">lb4</option><option value="id5">lb5</option></select>',
    "select() labels by row"
;

is $generator->select( %by_col, labels => 1, texts => 'id2' ),
    '<select><option value="id1">lb1</option><option selected="selected" value="id2">lb2</option><option value="id3">lb3</option><option value="id4">lb4</option><option value="id5">lb5</option></select>',
    "select() selected text"
;

is $generator->select( %by_col, labels => 1, texts => [qw( id2 id4 )] ),
    '<select><option value="id1">lb1</option><option selected="selected" value="id2">lb2</option><option value="id3">lb3</option><option selected="selected" value="id4">lb4</option><option value="id5">lb5</option></select>',
    "select() selected texts"
;

is $generator->select( %by_col, labels => 1, values => 'lb1' ),
    '<select><option selected="selected" value="id1">lb1</option><option value="id2">lb2</option><option value="id3">lb3</option><option value="id4">lb4</option><option value="id5">lb5</option></select>',
    "select() selected value"
;

is $generator->select( %by_col, labels => 1, values => [qw( lb2 lb3 )] ),
    '<select><option value="id1">lb1</option><option selected="selected" value="id2">lb2</option><option selected="selected" value="id3">lb3</option><option value="id4">lb4</option><option value="id5">lb5</option></select>',
    "select() selected values"
;

is $generator->select( %by_col, col => 1, labels => 1, encode => 1 ),
    '<select><option value="lb1">&lt;extra&gt;</option><option value="lb2">&lt;extra&gt;</option><option value="lb3">&lt;extra&gt;</option><option value="lb4">&lt;extra&gt;</option><option value="lb5">&lt;extra&gt;</option></select>',
    "select() default encoded texts by col"
;

is $generator->select( %by_row, row => 1, labels => 1, encode => 1 ),
    '<select><option value="lb1">&lt;extra&gt;</option><option value="lb2">&lt;extra&gt;</option><option value="lb3">&lt;extra&gt;</option><option value="lb4">&lt;extra&gt;</option><option value="lb5">&lt;extra&gt;</option></select>',
    "select() default encoded texts by row"
;

is $generator->select( %by_col, col => 1, labels => 1, encodes => 'a' ),
    '<select><option value="lb1"><extr&#97;></option><option value="lb2"><extr&#97;></option><option value="lb3"><extr&#97;></option><option value="lb4"><extr&#97;></option><option value="lb5"><extr&#97;></option></select>',
    "select() specific encoded texts by col"
;

is $generator->generate( %by_col ),
    '<table><tr><th>id1</th><th>lb1</th><th><extra></th><th>extra</th></tr><tr><td>id2</td><td>lb2</td><td><extra></td><td>extra</td></tr><tr><td>id3</td><td>lb3</td><td><extra></td><td>extra</td></tr><tr><td>id4</td><td>lb4</td><td><extra></td><td>extra</td></tr><tr><td>id5</td><td>lb5</td><td><extra></td><td>extra</td></tr></table>',
    "select() encoding does not persist"
;


is $generator->select( %by_col, col => 2, labels => 1, encode => 1 ),
    '<select><option value="<extra>">extra</option><option value="<extra>">extra</option><option value="<extra>">extra</option><option value="<extra>">extra</option><option value="<extra>">extra</option></select>',
    "select() attribute names are NOT encoded"
;

is $generator->select( %by_col, placeholder => 'select' ),
    '<select><option value="">select</option><option>id1</option><option>id2</option><option>id3</option><option>id4</option><option>id5</option></select>',
    "select() placeholder param correct"
;

is $generator->select( %by_col, labels => 1, placeholder => 'select' ),
    '<select><option value="">select</option><option value="id1">lb1</option><option value="id2">lb2</option><option value="id3">lb3</option><option value="id4">lb4</option><option value="id5">lb5</option></select>',
    "select() placeholder param with labels param correct"
;

