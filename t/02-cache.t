#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 10;

use Spreadsheet::HTML;

my $expected = [ [{ tag => 'th', cdata => 1 }] ];
my $table = Spreadsheet::HTML->new( data => 1 );
is_deeply scalar $table->process, $expected,                    "correct data processed";
is_deeply $table->{data}, 1,                                    "internal data has changed";

$table = Spreadsheet::HTML->new( data => 1, cache => 1 );
is_deeply scalar $table->process, $expected,                    "correct data processed";
is_deeply $table->{data}, $expected,                            "internal data has changed";

$expected = [ [{ tag => 'th', cdata => 2 }] ];
$table = Spreadsheet::HTML->new( data => 2 );
is_deeply scalar $table->process, $expected,                    "correct data processed";
is_deeply $table->{data}, 2,                                    "internal data not changed";
is_deeply scalar $table->process( cache => 1 ), $expected,      "correct data processed";
is_deeply $table->{data}, $expected,                            "internal data has changed";

SKIP: {
    skip "changing internals", 2;
my $data = [ map ['a'..'d'], 1.. 4 ];
$table = Spreadsheet::HTML->new( data => $data, cache => 1 );
is $table->generate,
    '<table><tr><th>a</th><th>b</th><th>c</th><th>d</th></tr><tr><td>a</td><td>b</td><td>c</td><td>d</td></tr><tr><td>a</td><td>b</td><td>c</td><td>d</td></tr><tr><td>a</td><td>b</td><td>c</td><td>d</td></tr></table>',
    "generate is correct";
is $table->generate( data => 1 ),
    '<table><tr><th>a</th><th>b</th><th>c</th><th>d</th></tr><tr><td>a</td><td>b</td><td>c</td><td>d</td></tr><tr><td>a</td><td>b</td><td>c</td><td>d</td></tr><tr><td>a</td><td>b</td><td>c</td><td>d</td></tr></table>',
    "generate is still correct";
};
