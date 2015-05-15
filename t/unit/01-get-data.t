#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 10;
use Data::Dumper;

use_ok 'Spreadsheet::HTML';

my $data = [
    [qw(header1 header2 header3 header4 )],
    [qw(foo1 bar1 baz1 qux1)],
    [qw(foo2 bar2 baz2 qux2)],
    [qw(foo3 bar3 baz3 qux3)],
    [qw(foo4 bar4 baz4 qux4)],
];

my $construct_with_list = new_ok 'Spreadsheet::HTML', [ data => $data ];
is_deeply [ $construct_with_list->get_data ], $data,  "correct data from interface for construct_with_list";
is_deeply $construct_with_list->{data}, $data,  "correct data from internal for construct_with_list";

my $construct_with_ref = Spreadsheet::HTML->new( { data => $data } );
is_deeply [ $construct_with_ref->get_data ], $data,  "correct data from interface for construct_with_ref";
is_deeply $construct_with_ref->{data}, $data,  "correct data from internal for construct_with_ref";

is_deeply [ Spreadsheet::HTML::get_data( $data ) ], $data,  "correct output for array ref";
is_deeply [ Spreadsheet::HTML::get_data( @$data ) ], $data,  "correct output for array";

my $test_processed = Spreadsheet::HTML->new( data => $data );
is $test_processed->{__processed_data__}, undef, "data has not been processed";
$test_processed->get_data;
is $test_processed->{__processed_data__}, 1, "data has been processed";

my $enc_data = [
    [ qw( < = & > ) ],
    [ qw( < = & > ) ],
];

