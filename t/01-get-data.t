#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 8;
use Data::Dumper;

use Spreadsheet::HTML;

my $data = [
    [qw(header1 header2 header3 header4 )],
    [qw(foo1 bar1 baz1 qux1)],
    [qw(foo2 bar2 baz2 qux2)],
    [qw(foo3 bar3 baz3 qux3)],
    [qw(foo4 bar4 baz4 qux4)],
];
my $expected = [
    [['header1'],['header2'],['header3'],['header4']],
    [qw(foo1 bar1 baz1 qux1)],
    [qw(foo2 bar2 baz2 qux2)],
    [qw(foo3 bar3 baz3 qux3)],
    [qw(foo4 bar4 baz4 qux4)],
];

my $construct_with_list = new_ok 'Spreadsheet::HTML', [ data => $data ];
is_deeply [ $construct_with_list->process_data ], $expected,  "expected data from interface for construct_with_list";
is_deeply $construct_with_list->{data}, $expected,  "expected data from internal for construct_with_list";

my $construct_with_ref = new_ok 'Spreadsheet::HTML', [ { data => $data } ];
is_deeply [ $construct_with_ref->process_data ], $expected,  "expected data from interface for construct_with_ref";
is_deeply $construct_with_ref->{data}, $expected,  "expected data from internal for construct_with_ref";

is_deeply [ Spreadsheet::HTML::process_data( $data ) ], $expected,  "expected output for array ref";
is_deeply [ Spreadsheet::HTML::process_data( @$data ) ], $expected,  "expected output for array";
