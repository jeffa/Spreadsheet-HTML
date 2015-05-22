#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 2;
use Data::Dumper;

use Spreadsheet::HTML;

my $test_processed = Spreadsheet::HTML->new( data => [] );

SKIP: {
    skip "rewrite this test to use 'cached' attr instead", 2;
is $test_processed->{__processed_data__}, undef, "data has not been processed";
$test_processed->process_data;
is $test_processed->{__processed_data__}, 1, "data has been processed";
};
