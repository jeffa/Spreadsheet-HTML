#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 23;

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

is $table->generate( -r0 => sub { ucfirst shift } ),
    '<table><tr><th>Header1</th><th>Header2</th><th>Header3</th><th>Header4</th></tr><tr><td>foo1</td><td>bar1</td><td>baz1</td><td>qux1</td></tr><tr><td>foo2</td><td>bar2</td><td>baz2</td><td>qux2</td></tr><tr><td>foo3</td><td>bar3</td><td>baz3</td><td>qux3</td></tr><tr><td>foo4</td><td>bar4</td><td>baz4</td><td>qux4</td></tr></table>',
    "headings is an alias for -r0";

is $table->generate( -r2 => sub { uc shift } ),
    '<table><tr><th>header1</th><th>header2</th><th>header3</th><th>header4</th></tr><tr><td>foo1</td><td>bar1</td><td>baz1</td><td>qux1</td></tr><tr><td>FOO2</td><td>BAR2</td><td>BAZ2</td><td>QUX2</td></tr><tr><td>foo3</td><td>bar3</td><td>baz3</td><td>qux3</td></tr><tr><td>foo4</td><td>bar4</td><td>baz4</td><td>qux4</td></tr></table>',
    "modify all cells in one row by row number";

is $table->generate( -c2 => sub { uc shift } ),
    '<table><tr><th>header1</th><th>header2</th><th>HEADER3</th><th>header4</th></tr><tr><td>foo1</td><td>bar1</td><td>BAZ1</td><td>qux1</td></tr><tr><td>foo2</td><td>bar2</td><td>BAZ2</td><td>qux2</td></tr><tr><td>foo3</td><td>bar3</td><td>BAZ3</td><td>qux3</td></tr><tr><td>foo4</td><td>bar4</td><td>BAZ4</td><td>qux4</td></tr></table>',
    "modify all cells in one column by column number";

is $table->generate( td => sub { uc shift } ),
    '<table><tr><th>header1</th><th>header2</th><th>header3</th><th>header4</th></tr><tr><td>FOO1</td><td>BAR1</td><td>BAZ1</td><td>QUX1</td></tr><tr><td>FOO2</td><td>BAR2</td><td>BAZ2</td><td>QUX2</td></tr><tr><td>FOO3</td><td>BAR3</td><td>BAZ3</td><td>QUX3</td></tr><tr><td>FOO4</td><td>BAR4</td><td>BAZ4</td><td>QUX4</td></tr></table>',
    "modify all td cells";

is $table->generate( headings => sub { uc shift } ),
    $table->generate( th => sub { uc shift } ),
    "headings has same impact as th";


is $table->generate( -header3 => sub { "<b>$_[0]</b>" } ),
    '<table><tr><th>header1</th><th>header2</th><th><b>header3</b></th><th>header4</th></tr><tr><td>foo1</td><td>bar1</td><td><b>baz1</b></td><td>qux1</td></tr><tr><td>foo2</td><td>bar2</td><td><b>baz2</b></td><td>qux2</td></tr><tr><td>foo3</td><td>bar3</td><td><b>baz3</b></td><td>qux3</td></tr><tr><td>foo4</td><td>bar4</td><td><b>baz4</b></td><td>qux4</td></tr></table>',
    "modify all cells in one column by heading name";

is $table->generate( -r0 => { style => { color => [qw(blue red)] } } ),
    '<table><tr><th style="color: blue">header1</th><th style="color: red">header2</th><th style="color: blue">header3</th><th style="color: red">header4</th></tr><tr><td>foo1</td><td>bar1</td><td>baz1</td><td>qux1</td></tr><tr><td>foo2</td><td>bar2</td><td>baz2</td><td>qux2</td></tr><tr><td>foo3</td><td>bar3</td><td>baz3</td><td>qux3</td></tr><tr><td>foo4</td><td>bar4</td><td>baz4</td><td>qux4</td></tr></table>',
    "-r0 refers to th when applying styles";

is $table->generate( -r2 => { style => { color => [qw(blue red)] } } ),
    '<table><tr><th>header1</th><th>header2</th><th>header3</th><th>header4</th></tr><tr><td>foo1</td><td>bar1</td><td>baz1</td><td>qux1</td></tr><tr><td style="color: blue">foo2</td><td style="color: red">bar2</td><td style="color: blue">baz2</td><td style="color: red">qux2</td></tr><tr><td>foo3</td><td>bar3</td><td>baz3</td><td>qux3</td></tr><tr><td>foo4</td><td>bar4</td><td>baz4</td><td>qux4</td></tr></table>',
    "apply styles by row";

is $table->generate( -c2 => { style => { color => [qw(blue red)] } } ),
    '<table><tr><th>header1</th><th>header2</th><th style="color: blue">header3</th><th>header4</th></tr><tr><td>foo1</td><td>bar1</td><td style="color: red">baz1</td><td>qux1</td></tr><tr><td>foo2</td><td>bar2</td><td style="color: blue">baz2</td><td>qux2</td></tr><tr><td>foo3</td><td>bar3</td><td style="color: red">baz3</td><td>qux3</td></tr><tr><td>foo4</td><td>bar4</td><td style="color: blue">baz4</td><td>qux4</td></tr></table>',
    "apply styles by column";

is $table->generate( -header3 => { style => { color => [qw(blue red)] } } ),
    '<table><tr><th>header1</th><th>header2</th><th style="color: blue">header3</th><th>header4</th></tr><tr><td>foo1</td><td>bar1</td><td style="color: red">baz1</td><td>qux1</td></tr><tr><td>foo2</td><td>bar2</td><td style="color: blue">baz2</td><td>qux2</td></tr><tr><td>foo3</td><td>bar3</td><td style="color: red">baz3</td><td>qux3</td></tr><tr><td>foo4</td><td>bar4</td><td style="color: blue">baz4</td><td>qux4</td></tr></table>',
    "apply styles to column heading name";

is $table->generate( td => { style => { color => [qw(blue red)] } } ),
    '<table><tr><th>header1</th><th>header2</th><th>header3</th><th>header4</th></tr><tr><td style="color: blue">foo1</td><td style="color: red">bar1</td><td style="color: blue">baz1</td><td style="color: red">qux1</td></tr><tr><td style="color: blue">foo2</td><td style="color: red">bar2</td><td style="color: blue">baz2</td><td style="color: red">qux2</td></tr><tr><td style="color: blue">foo3</td><td style="color: red">bar3</td><td style="color: blue">baz3</td><td style="color: red">qux3</td></tr><tr><td style="color: blue">foo4</td><td style="color: red">bar4</td><td style="color: blue">baz4</td><td style="color: red">qux4</td></tr></table>',
    "apply styles to all td cells";


is $table->generate( headings => [ sub {ucfirst shift}, { style => { color => [qw(blue red)] } } ] ),
    '<table><tr><th style="color: blue">Header1</th><th style="color: red">Header2</th><th style="color: blue">Header3</th><th style="color: red">Header4</th></tr><tr><td>foo1</td><td>bar1</td><td>baz1</td><td>qux1</td></tr><tr><td>foo2</td><td>bar2</td><td>baz2</td><td>qux2</td></tr><tr><td>foo3</td><td>bar3</td><td>baz3</td><td>qux3</td></tr><tr><td>foo4</td><td>bar4</td><td>baz4</td><td>qux4</td></tr></table>',
    "modify cells and apply styles to headings";

is $table->generate( -r2 => [ sub {ucfirst shift}, { style => { color => [qw(blue red)] } } ] ),
    '<table><tr><th>header1</th><th>header2</th><th>header3</th><th>header4</th></tr><tr><td>foo1</td><td>bar1</td><td>baz1</td><td>qux1</td></tr><tr><td style="color: blue">Foo2</td><td style="color: red">Bar2</td><td style="color: blue">Baz2</td><td style="color: red">Qux2</td></tr><tr><td>foo3</td><td>bar3</td><td>baz3</td><td>qux3</td></tr><tr><td>foo4</td><td>bar4</td><td>baz4</td><td>qux4</td></tr></table>',
    "modify cells and apply styles by row";

is $table->generate( -c2 => [ sub {ucfirst shift}, { style => { color => [qw(blue red)] } } ] ),
    '<table><tr><th>header1</th><th>header2</th><th style="color: blue">Header3</th><th>header4</th></tr><tr><td>foo1</td><td>bar1</td><td style="color: red">Baz1</td><td>qux1</td></tr><tr><td>foo2</td><td>bar2</td><td style="color: blue">Baz2</td><td>qux2</td></tr><tr><td>foo3</td><td>bar3</td><td style="color: red">Baz3</td><td>qux3</td></tr><tr><td>foo4</td><td>bar4</td><td style="color: blue">Baz4</td><td>qux4</td></tr></table>',
    "modify cells and apply styles by column";

is $table->generate( -header2 => [ sub {ucfirst shift}, { style => { color => [qw(blue red)] } } ] ),
    '<table><tr><th>header1</th><th style="color: blue">Header2</th><th>header3</th><th>header4</th></tr><tr><td>foo1</td><td style="color: red">Bar1</td><td>baz1</td><td>qux1</td></tr><tr><td>foo2</td><td style="color: blue">Bar2</td><td>baz2</td><td>qux2</td></tr><tr><td>foo3</td><td style="color: red">Bar3</td><td>baz3</td><td>qux3</td></tr><tr><td>foo4</td><td style="color: blue">Bar4</td><td>baz4</td><td>qux4</td></tr></table>',
    "modify cells and apply styles to column heading name";

is $table->generate( td => [ sub {ucfirst shift}, { style => { color => [qw(blue red)] } } ] ),
    '<table><tr><th>header1</th><th>header2</th><th>header3</th><th>header4</th></tr><tr><td style="color: blue">Foo1</td><td style="color: red">Bar1</td><td style="color: blue">Baz1</td><td style="color: red">Qux1</td></tr><tr><td style="color: blue">Foo2</td><td style="color: red">Bar2</td><td style="color: blue">Baz2</td><td style="color: red">Qux2</td></tr><tr><td style="color: blue">Foo3</td><td style="color: red">Bar3</td><td style="color: blue">Baz3</td><td style="color: red">Qux3</td></tr><tr><td style="color: blue">Foo4</td><td style="color: red">Bar4</td><td style="color: blue">Baz4</td><td style="color: red">Qux4</td></tr></table>',
    "modify cells and apply styles to all cells";

is $table->generate( headings => { bgcolor => 'white' }, -header2 => { bgcolor => 'red' } ),
    '<table><tr><th bgcolor="white">header1</th><th bgcolor="white">header2</th><th bgcolor="white">header3</th><th bgcolor="white">header4</th></tr><tr><td>foo1</td><td bgcolor="red">bar1</td><td>baz1</td><td>qux1</td></tr><tr><td>foo2</td><td bgcolor="red">bar2</td><td>baz2</td><td>qux2</td></tr><tr><td>foo3</td><td bgcolor="red">bar3</td><td>baz3</td><td>qux3</td></tr><tr><td>foo4</td><td bgcolor="red">bar4</td><td>baz4</td><td>qux4</td></tr></table>',
    "headings override -cX";

is $table->generate( headings => sub { uc shift }, -r1 => sub { uc shift }, th => { class => 'foo' } ),
    '<table><tr><th class="foo">HEADER1</th><th class="foo">HEADER2</th><th class="foo">HEADER3</th><th class="foo">HEADER4</th></tr><tr><td>FOO1</td><td>BAR1</td><td>BAZ1</td><td>QUX1</td></tr><tr><td>foo2</td><td>bar2</td><td>baz2</td><td>qux2</td></tr><tr><td>foo3</td><td>bar3</td><td>baz3</td><td>qux3</td></tr><tr><td>foo4</td><td>bar4</td><td>baz4</td><td>qux4</td></tr></table>',
    "th attrs are not clobbered by headings or row subs";

is $table->generate( headings => sub { uc shift }, -r1 => sub { uc shift }, td => { class => 'foo' } ),
    '<table><tr><th>HEADER1</th><th>HEADER2</th><th>HEADER3</th><th>HEADER4</th></tr><tr><td class="foo">FOO1</td><td class="foo">BAR1</td><td class="foo">BAZ1</td><td class="foo">QUX1</td></tr><tr><td class="foo">foo2</td><td class="foo">bar2</td><td class="foo">baz2</td><td class="foo">qux2</td></tr><tr><td class="foo">foo3</td><td class="foo">bar3</td><td class="foo">baz3</td><td class="foo">qux3</td></tr><tr><td class="foo">foo4</td><td class="foo">bar4</td><td class="foo">baz4</td><td class="foo">qux4</td></tr></table>',
    "th attrs are not clobbered by headings or row subs";


is $table->generate( td => {class=>'td'}, -c1 => {class=>'col1'}, -r2 => {class=>'row2'}, -r2c1 => {class=>'row2col1'} ),
    '<table><tr><th>header1</th><th class="col1">header2</th><th>header3</th><th>header4</th></tr><tr><td class="td">foo1</td><td class="col1">bar1</td><td class="td">baz1</td><td class="td">qux1</td></tr><tr><td class="row2">foo2</td><td class="row2col1">bar2</td><td class="row2">baz2</td><td class="row2">qux2</td></tr><tr><td class="td">foo3</td><td class="col1">bar3</td><td class="td">baz3</td><td class="td">qux3</td></tr><tr><td class="td">foo4</td><td class="col1">bar4</td><td class="td">baz4</td><td class="td">qux4</td></tr></table>',
    "correct overrides";
