#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 11;

use Spreadsheet::HTML;

my $data = [
    [qw(header1 header2 header3 header4 )],
    [qw(foo1 bar1 baz1 qux1)],
    [qw(foo2 bar2 baz2 qux2)],
    [qw(foo3 bar3 baz3 qux3)],
    [qw(foo4 bar4 baz4 qux4)],
];

my $table = Spreadsheet::HTML->new( data => $data );

is $table->generate,
    '<table><tr><th>header1</th><th>header2</th><th>header3</th><th>header4</th></tr><tr><td>foo1</td><td>bar1</td><td>baz1</td><td>qux1</td></tr><tr><td>foo2</td><td>bar2</td><td>baz2</td><td>qux2</td></tr><tr><td>foo3</td><td>bar3</td><td>baz3</td><td>qux3</td></tr><tr><td>foo4</td><td>bar4</td><td>baz4</td><td>qux4</td></tr></table>',
    "default headers untouched";

is $table->generate( headings => sub { ucfirst shift } ),
    '<table><tr><th>Header1</th><th>Header2</th><th>Header3</th><th>Header4</th></tr><tr><td>foo1</td><td>bar1</td><td>baz1</td><td>qux1</td></tr><tr><td>foo2</td><td>bar2</td><td>baz2</td><td>qux2</td></tr><tr><td>foo3</td><td>bar3</td><td>baz3</td><td>qux3</td></tr><tr><td>foo4</td><td>bar4</td><td>baz4</td><td>qux4</td></tr></table>',
    "headers changed";

is $table->generate( headings => sub { ucfirst shift }, headless => 1 ),
    '<table><tr><td>foo1</td><td>bar1</td><td>baz1</td><td>qux1</td></tr><tr><td>foo2</td><td>bar2</td><td>baz2</td><td>qux2</td></tr><tr><td>foo3</td><td>bar3</td><td>baz3</td><td>qux3</td></tr><tr><td>foo4</td><td>bar4</td><td>baz4</td><td>qux4</td></tr></table>',
    "configuring headings on headless does not impact next row";

is $table->generate( -row0 => sub { ucfirst shift } ),
    '<table><tr><th>Header1</th><th>Header2</th><th>Header3</th><th>Header4</th></tr><tr><td>foo1</td><td>bar1</td><td>baz1</td><td>qux1</td></tr><tr><td>foo2</td><td>bar2</td><td>baz2</td><td>qux2</td></tr><tr><td>foo3</td><td>bar3</td><td>baz3</td><td>qux3</td></tr><tr><td>foo4</td><td>bar4</td><td>baz4</td><td>qux4</td></tr></table>',
    "headings is an alias for -row0";

is $table->generate( -row2 => sub { uc shift } ),
    '<table><tr><th>header1</th><th>header2</th><th>header3</th><th>header4</th></tr><tr><td>foo1</td><td>bar1</td><td>baz1</td><td>qux1</td></tr><tr><td>FOO2</td><td>BAR2</td><td>BAZ2</td><td>QUX2</td></tr><tr><td>foo3</td><td>bar3</td><td>baz3</td><td>qux3</td></tr><tr><td>foo4</td><td>bar4</td><td>baz4</td><td>qux4</td></tr></table>',
    "modify all cells in one row by row number";

is $table->generate( -col2 => sub { uc shift } ),
    '<table><tr><th>header1</th><th>header2</th><th>header3</th><th>header4</th></tr><tr><td>foo1</td><td>bar1</td><td>BAZ1</td><td>qux1</td></tr><tr><td>foo2</td><td>bar2</td><td>BAZ2</td><td>qux2</td></tr><tr><td>foo3</td><td>bar3</td><td>BAZ3</td><td>qux3</td></tr><tr><td>foo4</td><td>bar4</td><td>BAZ4</td><td>qux4</td></tr></table>',
    "modify all cells in one column by column number";

is $table->generate( -header3 => sub { "<b>$_[0]</b>" } ),
    '<table><tr><th>header1</th><th>header2</th><th>header3</th><th>header4</th></tr><tr><td>foo1</td><td>bar1</td><td><b>baz1</b></td><td>qux1</td></tr><tr><td>foo2</td><td>bar2</td><td><b>baz2</b></td><td>qux2</td></tr><tr><td>foo3</td><td>bar3</td><td><b>baz3</b></td><td>qux3</td></tr><tr><td>foo4</td><td>bar4</td><td><b>baz4</b></td><td>qux4</td></tr></table>',
    "modify all cells in one column by heading name";

is $table->generate( -row0 => { style => { color => [qw(blue red)] } } ),
    '<table><tr><th style="color: blue">header1</th><th style="color: red">header2</th><th style="color: blue">header3</th><th style="color: red">header4</th></tr><tr><td>foo1</td><td>bar1</td><td>baz1</td><td>qux1</td></tr><tr><td>foo2</td><td>bar2</td><td>baz2</td><td>qux2</td></tr><tr><td>foo3</td><td>bar3</td><td>baz3</td><td>qux3</td></tr><tr><td>foo4</td><td>bar4</td><td>baz4</td><td>qux4</td></tr></table>',
    "-row0 refers to th when applying styles";

is $table->generate( -row2 => { style => { color => [qw(blue red)] } } ),
    '<table><tr><th>header1</th><th>header2</th><th>header3</th><th>header4</th></tr><tr><td>foo1</td><td>bar1</td><td>baz1</td><td>qux1</td></tr><tr><td style="color: blue">foo2</td><td style="color: red">bar2</td><td style="color: blue">baz2</td><td style="color: red">qux2</td></tr><tr><td>foo3</td><td>bar3</td><td>baz3</td><td>qux3</td></tr><tr><td>foo4</td><td>bar4</td><td>baz4</td><td>qux4</td></tr></table>',
    "apply styles by row";

is $table->generate( -col2 => { style => { color => [qw(blue red)] } } ),
    '<table><tr><th>header1</th><th>header2</th><th>header3</th><th>header4</th></tr><tr><td>foo1</td><td>bar1</td><td style="color: blue">baz1</td><td>qux1</td></tr><tr><td>foo2</td><td>bar2</td><td style="color: red">baz2</td><td>qux2</td></tr><tr><td>foo3</td><td>bar3</td><td style="color: blue">baz3</td><td>qux3</td></tr><tr><td>foo4</td><td>bar4</td><td style="color: red">baz4</td><td>qux4</td></tr></table>',
    "apply styles by column";

is $table->generate( -header3 => { style => { color => [qw(blue red)] } } ),
    '<table><tr><th>header1</th><th>header2</th><th>header3</th><th>header4</th></tr><tr><td>foo1</td><td>bar1</td><td style="color: blue">baz1</td><td>qux1</td></tr><tr><td>foo2</td><td>bar2</td><td style="color: red">baz2</td><td>qux2</td></tr><tr><td>foo3</td><td>bar3</td><td style="color: blue">baz3</td><td>qux3</td></tr><tr><td>foo4</td><td>bar4</td><td style="color: red">baz4</td><td>qux4</td></tr></table>',
    "apply styles to column heading name";
