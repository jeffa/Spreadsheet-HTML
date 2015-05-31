#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 3;

use Spreadsheet::HTML;

my $data = [
    [('a' .. 'c')],
    [( 1 .. 3 )],
    [( 4 .. 6 )],
];

my $table = Spreadsheet::HTML->new( data => $data, caption => { "My Table" => { key => 'value' } } );

is $table->generate,
    '<table><caption key="value">My Table</caption><tr><th>a</th><th>b</th><th>c</th></tr><tr><td>1</td><td>2</td><td>3</td></tr><tr><td>4</td><td>5</td><td>6</td></tr></table>',
    "caption present from generate()";

is $table->generate( tgroups => 1 ),
    '<table><caption key="value">My Table</caption><thead><tr><th>a</th><th>b</th><th>c</th></tr></thead><tfoot><tr><td>4</td><td>5</td><td>6</td></tr></tfoot><tbody><tr><td>1</td><td>2</td><td>3</td></tr></tbody></table>',
    "caption present from generate() with tgroups";

is $table->generate( caption => 0 ),
    '<table><caption>0</caption><tr><th>a</th><th>b</th><th>c</th></tr><tr><td>1</td><td>2</td><td>3</td></tr><tr><td>4</td><td>5</td><td>6</td></tr></table>',
    "caption can be overriden";
