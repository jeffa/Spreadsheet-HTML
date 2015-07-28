#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 5;

use Spreadsheet::HTML;

my $data = [
    [('a' .. 'c')],
    [( 1 .. 3 )],
    [( 4 .. 6 )],
];

my $table = Spreadsheet::HTML->new( data => $data, col => { span => 3, width => '100' }, sorted_attrs => 1 );

is $table->generate,
    '<table><colgroup><col span="3" width="100" /></colgroup><tr><th>a</th><th>b</th><th>c</th></tr><tr><td>1</td><td>2</td><td>3</td></tr><tr><td>4</td><td>5</td><td>6</td></tr></table>',
    "col present from generate()";

is $table->generate( tgroups => 2 ),
    '<table><colgroup><col span="3" width="100" /></colgroup><thead><tr><th>a</th><th>b</th><th>c</th></tr></thead><tfoot><tr><td>4</td><td>5</td><td>6</td></tr></tfoot><tbody><tr><td>1</td><td>2</td><td>3</td></tr></tbody></table>',
    "col present from generate() with tgroups";

is $table->generate( col => undef ),
    '<table><tr><th>a</th><th>b</th><th>c</th></tr><tr><td>1</td><td>2</td><td>3</td></tr><tr><td>4</td><td>5</td><td>6</td></tr></table>',
    "col can be overriden";

is $table->generate( col => [ { span => 1, color => 'red' }, { span => 2, color => 'blue' } ] ),
    '<table><colgroup><col color="red" span="1" /><col color="blue" span="2" /></colgroup><tr><th>a</th><th>b</th><th>c</th></tr><tr><td>1</td><td>2</td><td>3</td></tr><tr><td>4</td><td>5</td><td>6</td></tr></table>',
    "can specify multiple cols";

is $table->generate( colgroup => { class => 'cols' }, col => [ { span => 1, color => 'red' }, { span => 2, color => 'blue' } ] ),
    '<table><colgroup class="cols"><col color="red" span="1" /><col color="blue" span="2" /></colgroup><tr><th>a</th><th>b</th><th>c</th></tr><tr><td>1</td><td>2</td><td>3</td></tr><tr><td>4</td><td>5</td><td>6</td></tr></table>',
    "can specify still apply colgroups attributes";
