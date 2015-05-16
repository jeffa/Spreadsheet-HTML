#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 6;
use Data::Dumper;

use Spreadsheet::HTML;

my $encodes = [
    [ qw( < = & > ) ],
    [ qw( < = & > ) ],
];
my $spaces = [
    [ "\n", "foo\n", " ", " \n" ],
    [ "\n", "foo\n", " ", " \n" ],
];

my $expected_encodes = [
    [ ['&lt;'], ['='], ['&amp;'], ['&gt;'] ],
    [ qw( &lt; = &amp; &gt; ) ],
];
my $expected_spaces = [
    [ ['&nbsp;'], ['foo<br />'], ['&nbsp;'], ['&nbsp;'] ],
    [ '&nbsp;', 'foo<br />', '&nbsp;', '&nbsp;' ],
];

my $table = new_ok 'Spreadsheet::HTML', [ data => $encodes ];
is_deeply [ $table->process_data ], $expected_encodes,  "correctly encoded data";
is_deeply [ $table->process_data ], $expected_encodes,  "only processes once";

$table = new_ok 'Spreadsheet::HTML', [ data => $spaces ];
is_deeply [ $table->process_data ], $expected_spaces,  "correctly substituted spaces";
is_deeply [ $table->process_data ], $expected_spaces,  "only processes once";
