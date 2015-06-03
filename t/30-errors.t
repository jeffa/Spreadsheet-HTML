#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 5;

use Spreadsheet::HTML;

my $table = Spreadsheet::HTML->new;

is $table->generate( file => 'foo.csv' ),
    '<table><tr><th>cannot load foo.csv</th></tr><tr><td>No such file or directory</td></tr></table>',
    "handle missing CSV file";

is $table->generate( file => 'foo.html' ),
    '<table><tr><th>cannot load foo.html</th></tr><tr><td>No such file or directory</td></tr></table>',
    "handle missing HTML file";

is $table->generate( file => 'foo.json' ),
    '<table><tr><th>cannot load foo.json</th></tr><tr><td>No such file or directory</td></tr></table>',
    "handle missing JSON file";

is $table->generate( file => 'foo.xls' ),
    '<table><tr><th>cannot load foo.xls</th></tr><tr><td>No such file or directory</td></tr></table>',
    "handle missing XLS file";

is $table->generate( file => 'foo.yaml' ),
    '<table><tr><th>cannot load foo.yaml</th></tr><tr><td>No such file or directory</td></tr></table>',
    "handle missing YAML file";

