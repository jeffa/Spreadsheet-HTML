#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 11;

use Spreadsheet::HTML;

my $data = [
    [('a' .. 'c')],
    [( 1 .. 3 )],
    [( 4 .. 6 )],
];

my $table = Spreadsheet::HTML->new( data => $data, colgroup => { span => 3, width => '100' }, sorted_attrs => 1 );

is $table->generate,
    '<table><colgroup span="3" width="100" /><tr><th>a</th><th>b</th><th>c</th></tr><tr><td>1</td><td>2</td><td>3</td></tr><tr><td>4</td><td>5</td><td>6</td></tr></table>',
    "colgroup present from generate()";

is $table->generate( tgroups => 2 ),
    '<table><colgroup span="3" width="100" /><thead><tr><th>a</th><th>b</th><th>c</th></tr></thead><tfoot><tr><td>4</td><td>5</td><td>6</td></tr></tfoot><tbody><tr><td>1</td><td>2</td><td>3</td></tr></tbody></table>',
    "colgroup present from generate() with tgroups";

is $table->generate( colgroup => undef ),
    '<table><tr><th>a</th><th>b</th><th>c</th></tr><tr><td>1</td><td>2</td><td>3</td></tr><tr><td>4</td><td>5</td><td>6</td></tr></table>',
    "colgroup can be overriden";

is $table->generate( colgroup => 1 ),
    '<table><tr><th>a</th><th>b</th><th>c</th></tr><tr><td>1</td><td>2</td><td>3</td></tr><tr><td>4</td><td>5</td><td>6</td></tr></table>',
    "colgroup yields no-op if scalar";

is $table->generate( colgroup => [ { span => 1, color => 'red' }, { span => 2, color => 'blue' } ] ),
    '<table><colgroup color="red" span="1" /><colgroup color="blue" span="2" /><tr><th>a</th><th>b</th><th>c</th></tr><tr><td>1</td><td>2</td><td>3</td></tr><tr><td>4</td><td>5</td><td>6</td></tr></table>',
    "can specify multiple colgroups";

is $table->generate( col => {} ),
    '<table><colgroup span="3" width="100"><col /></colgroup><tr><th>a</th><th>b</th><th>c</th></tr><tr><td>1</td><td>2</td><td>3</td></tr><tr><td>4</td><td>5</td><td>6</td></tr></table>',
    "colgroup wraps col";

is $table->generate( col => [{},{},{}] ),
    '<table><colgroup span="3" width="100"><col /><col /><col /></colgroup><tr><th>a</th><th>b</th><th>c</th></tr><tr><td>1</td><td>2</td><td>3</td></tr><tr><td>4</td><td>5</td><td>6</td></tr></table>',
    "colgroup wraps multple cols";

is $table->generate( colgroup => undef, col => {} ),
    '<table><colgroup><col /></colgroup><tr><th>a</th><th>b</th><th>c</th></tr><tr><td>1</td><td>2</td><td>3</td></tr><tr><td>4</td><td>5</td><td>6</td></tr></table>',
    "colgroup can be overriden when col is present too";


$table = Spreadsheet::HTML->new( data => $data, col => [{},{},{}] );

is $table->generate( colgroup => {} ),
    '<table><colgroup><col /><col /><col /></colgroup><tr><th>a</th><th>b</th><th>c</th></tr><tr><td>1</td><td>2</td><td>3</td></tr><tr><td>4</td><td>5</td><td>6</td></tr></table>',
    "multiple cols against single colgroup";

is $table->generate( col => undef, colgroup => [{},{},{}] ),
    '<table><colgroup /><colgroup /><colgroup /><tr><th>a</th><th>b</th><th>c</th></tr><tr><td>1</td><td>2</td><td>3</td></tr><tr><td>4</td><td>5</td><td>6</td></tr></table>',
    "no cols against multiple colgroups";

is $table->generate( colgroup => [{},{},{}] ),
    '<table><colgroup><col /><col /><col /></colgroup><colgroup><col /><col /><col /></colgroup><colgroup><col /><col /><col /></colgroup><tr><th>a</th><th>b</th><th>c</th></tr><tr><td>1</td><td>2</td><td>3</td></tr><tr><td>4</td><td>5</td><td>6</td></tr></table>',
    "multiple cols against multiple colgroups";

