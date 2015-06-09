#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 6;

use Spreadsheet::HTML;

my $data = [
    [qw(header1 header2 header3 header4 )],
    [qw(foo1 bar1 baz1 qux1)],
    [qw(foo2 bar2 baz2 qux2)],
    [qw(foo3 bar3 baz3 qux3)],
    [qw(foo4 bar4 baz4 qux4)],
];

my $table = Spreadsheet::HTML->new( data => $data, tgroups => 1 );

is $table->generate,
    '<table><thead><tr><th>header1</th><th>header2</th><th>header3</th><th>header4</th></tr></thead><tfoot><tr><td>foo4</td><td>bar4</td><td>baz4</td><td>qux4</td></tr></tfoot><tbody><tr><td>foo1</td><td>bar1</td><td>baz1</td><td>qux1</td></tr><tr><td>foo2</td><td>bar2</td><td>baz2</td><td>qux2</td></tr><tr><td>foo3</td><td>bar3</td><td>baz3</td><td>qux3</td></tr></tbody></table>',
    "tgroup tags present from generate()";

is $table->landscape,
    '<table><tr><th>header1</th><td>foo1</td><td>foo2</td><td>foo3</td><td>foo4</td></tr><tr><th>header2</th><td>bar1</td><td>bar2</td><td>bar3</td><td>bar4</td></tr><tr><th>header3</th><td>baz1</td><td>baz2</td><td>baz3</td><td>baz4</td></tr><tr><th>header4</th><td>qux1</td><td>qux2</td><td>qux3</td><td>qux4</td></tr></table>',
    "tgroup tags never present from landscape()";

is $table->north,
    '<table><thead><tr><th>header1</th><th>header2</th><th>header3</th><th>header4</th></tr></thead><tfoot><tr><td>foo4</td><td>bar4</td><td>baz4</td><td>qux4</td></tr></tfoot><tbody><tr><td>foo1</td><td>bar1</td><td>baz1</td><td>qux1</td></tr><tr><td>foo2</td><td>bar2</td><td>baz2</td><td>qux2</td></tr><tr><td>foo3</td><td>bar3</td><td>baz3</td><td>qux3</td></tr></tbody></table>',
    "tgroup tags present from north()";

is $table->west,
    '<table><tr><th>header1</th><td>foo1</td><td>foo2</td><td>foo3</td><td>foo4</td></tr><tr><th>header2</th><td>bar1</td><td>bar2</td><td>bar3</td><td>bar4</td></tr><tr><th>header3</th><td>baz1</td><td>baz2</td><td>baz3</td><td>baz4</td></tr><tr><th>header4</th><td>qux1</td><td>qux2</td><td>qux3</td><td>qux4</td></tr></table>',
    "tgroup tags never present from west()";

is $table->south,
    '<table><tr><td>foo1</td><td>bar1</td><td>baz1</td><td>qux1</td></tr><tr><td>foo2</td><td>bar2</td><td>baz2</td><td>qux2</td></tr><tr><td>foo3</td><td>bar3</td><td>baz3</td><td>qux3</td></tr><tr><td>foo4</td><td>bar4</td><td>baz4</td><td>qux4</td></tr><tr><th>header1</th><th>header2</th><th>header3</th><th>header4</th></tr></table>',
    "tgroup tags never present from south()";

is $table->east,
    '<table><tr><td>foo1</td><td>foo2</td><td>foo3</td><td>foo4</td><th>header1</th></tr><tr><td>bar1</td><td>bar2</td><td>bar3</td><td>bar4</td><th>header2</th></tr><tr><td>baz1</td><td>baz2</td><td>baz3</td><td>baz4</td><th>header3</th></tr><tr><td>qux1</td><td>qux2</td><td>qux3</td><td>qux4</td><th>header4</th></tr></table>',
    "tgroup tags never present from east()";
