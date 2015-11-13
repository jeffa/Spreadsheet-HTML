#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 35;

use Spreadsheet::HTML;

my $generator = Spreadsheet::HTML->new( sorted_attrs => 1 );

my %by_row = ( file => 't/data/list-byrow.csv' );
my %by_col = ( file => 't/data/list-bycol.csv' );

is $generator->select( %by_col ),
    '<select><option>id1</option><option>id2</option><option>id3</option><option>id4</option><option>id5</option></select>',
    "default select() args expect columns"
;

is $generator->select( %by_col, headless => 1 ),
    '<select><option>id2</option><option>id3</option><option>id4</option><option>id5</option></select>',
    "select() headless param removes first element"
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
    "select() select attribute works"
;

is $generator->select( %by_col, option => { class => [qw(odd even)] } ),
    '<select><option class="odd">id1</option><option class="even">id2</option><option class="odd">id3</option><option class="even">id4</option><option class="odd">id5</option></select>',
    "select() option attribute works"
;

is $generator->select( %by_col, option => sub { uc shift } ),
    '<select><option>ID1</option><option>ID2</option><option>ID3</option><option>ID4</option><option>ID5</option></select>',
    "select() option sub refs works"
;

is $generator->select( %by_col, option => [ { class => [qw(odd even)] }, sub { uc shift } ] ),
    '<select><option class="odd">ID1</option><option class="even">ID2</option><option class="odd">ID3</option><option class="even">ID4</option><option class="odd">ID5</option></select>',
    "select() option sub refs works"
;

is $generator->select( %by_col, option => [ { class => [qw(odd even)] }, sub { uc shift } ], texts => [qw(id2 id4)] ),
    '<select><option class="odd">ID1</option><option class="even" selected="selected">ID2</option><option class="odd">ID3</option><option class="even" selected="selected">ID4</option><option class="odd">ID5</option></select>',
    "select() option sub refs works with select texts"
;

is $generator->select( %by_col, option => { disabled => [undef, undef, 1] }),
    '<select><option>id1</option><option>id2</option><option disabled="1">id3</option><option>id4</option><option>id5</option></select>',
    "select() can disable specific options"
;

is $generator->select( %by_col, labels => 1 ),
    '<select><option value="id1">lb1</option><option value="id2">lb2</option><option value="id3">lb3</option><option value="id4">lb4</option><option value="id5">lb5</option></select>',
    "select() labels by default column"
;

is $generator->select( %by_col, labels => 1, headless => 1 ),
    '<select><option value="id2">lb2</option><option value="id3">lb3</option><option value="id4">lb4</option><option value="id5">lb5</option></select>',
    "select() headless works when labels is set"
;

is $generator->select( %by_col, labels => 1, option => { class => [qw(odd even)] } ),
    '<select><option class="odd" value="id1">lb1</option><option class="even" value="id2">lb2</option><option class="odd" value="id3">lb3</option><option class="even" value="id4">lb4</option><option class="odd" value="id5">lb5</option></select>',
    "select() option attributes with labels"
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

is $generator->select( %by_col, labels => 1, texts => [qw( id2 id4 )], option => { class => [qw(odd even)] } ),
    '<select><option class="odd" value="id1">lb1</option><option class="even" selected="selected" value="id2">lb2</option><option class="odd" value="id3">lb3</option><option class="even" selected="selected" value="id4">lb4</option><option class="odd" value="id5">lb5</option></select>',
    "select() option attributes with selected texts"
;

is $generator->select( %by_col, labels => 1, values => 'lb1' ),
    '<select><option selected="selected" value="id1">lb1</option><option value="id2">lb2</option><option value="id3">lb3</option><option value="id4">lb4</option><option value="id5">lb5</option></select>',
    "select() selected value"
;

is $generator->select( %by_col, labels => 1, col => 3, values => 'lb1' ),
    '<select><option value="extra" /><option value="extra" /><option value="extra" /><option value="extra" /><option value="extra" /></select>',
    "select() selected value out of bounds by col"
;

is $generator->select( %by_row, labels => 1, row => 3, values => 'lb1' ),
    '',
    "select() selected value out of bounds by row"
;

is $generator->select( %by_col, labels => 1, values => [qw( lb2 lb3 )] ),
    '<select><option value="id1">lb1</option><option selected="selected" value="id2">lb2</option><option selected="selected" value="id3">lb3</option><option value="id4">lb4</option><option value="id5">lb5</option></select>',
    "select() selected values"
;

is $generator->select( %by_col, labels => 1, values => [qw( lb2 lb3 )], option => { class => [qw(odd even)] } ),
    '<select><option class="odd" value="id1">lb1</option><option class="even" selected="selected" value="id2">lb2</option><option class="odd" selected="selected" value="id3">lb3</option><option class="even" value="id4">lb4</option><option class="odd" value="id5">lb5</option></select>',
    "select() option attributes with selected values"
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

is $generator->select( %by_col, placeholder => 'select', headless => 1 ),
    '<select><option value="">select</option><option>id2</option><option>id3</option><option>id4</option><option>id5</option></select>',
    "select() placeholder param correct"
;

is $generator->select( %by_col, labels => 1, placeholder => 'select' ),
    '<select><option value="">select</option><option value="id1">lb1</option><option value="id2">lb2</option><option value="id3">lb3</option><option value="id4">lb4</option><option value="id5">lb5</option></select>',
    "select() placeholder param with labels param correct"
;

my @optgroup = qw(ph1 ph2 ph3);
is $generator->select( %by_col, optgroup => \@optgroup ),
    '<select><optgroup label="ph1" /><option>id1</option><option>id2</option><optgroup label="ph2" /><option>id3</option><option>id4</option><optgroup label="ph3" /><option>id5</option></select>',
    "select() optgroup param works"
;

is $generator->select( %by_col, labels => 1, optgroup => \@optgroup ),
    '<select><optgroup label="ph1" /><option value="id1">lb1</option><option value="id2">lb2</option><optgroup label="ph2" /><option value="id3">lb3</option><option value="id4">lb4</option><optgroup label="ph3" /><option value="id5">lb5</option></select>',
    "select() optgroup param works with labels"
;

