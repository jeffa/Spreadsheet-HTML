#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 3;
use Data::Dumper;

use Spreadsheet::HTML;

my $data = [
    [qw(header1 header2 header3 header4 )],
    [qw(foo1 bar1 baz1 qux1)],
    [qw(foo2 bar2 baz2 qux2)],
    [qw(foo3 bar3 baz3 qux3)],
    [qw(foo4 bar4 baz4 qux4)],
];

my $test_processed = new_ok 'Spreadsheet::HTML', [ data => $data ];
is $test_processed->{__processed_data__}, undef, "data has not been processed";
$test_processed->get_data;
is $test_processed->{__processed_data__}, 1, "data has been processed";
