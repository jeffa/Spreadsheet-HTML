#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 6;

use Spreadsheet::HTML;

SKIP: {
    skip "cache no work :/", 6;
my $table = Spreadsheet::HTML->new( data => 1, cache => 1 );
is_deeply scalar $table->process, [ [[1]] ],     "correct data processed";
is_deeply $table->{data}, [ [1] ],                             "internal data has changed";

$table = Spreadsheet::HTML->new( data => 2 );
is_deeply scalar $table->process, [ [[2]] ],                   "correct data processed";
is_deeply $table->{data}, 2,                                   "internal data not changed";
is_deeply scalar $table->process( cache => 1 ), [ [[2]] ],     "correct data processed";
is_deeply $table->{data}, [ [2] ],                             "internal data has changed";

};
