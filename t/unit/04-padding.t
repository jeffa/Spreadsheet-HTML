#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 4;
use Data::Dumper;

use Spreadsheet::HTML;

my $no_list = new_ok 'Spreadsheet::HTML';
is_deeply [ $no_list->get_data ], [ [] ],  "correct data from interface for no_list";

my $data = [
    [ qw( a b c d ) ],
    [ qw( a b c ) ],
    [ qw( a b ) ],
    [ qw( a ) ],
    [ qw( a b c d e f g) ],
];

my $expected = [
    [ qw( a b c d ) ],
    [ qw( a b c &nbsp; ) ],
    [ qw( a b &nbsp; &nbsp; ) ],
    [ qw( a &nbsp; &nbsp; &nbsp; ) ],
    [ qw( a b c d e f g) ],
];

my $table = new_ok 'Spreadsheet::HTML', [ data => $data ];
is_deeply [ $table->get_data ], $expected,      "padding is correct";
