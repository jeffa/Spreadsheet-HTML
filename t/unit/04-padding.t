#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 32;
use Data::Dumper;

use Spreadsheet::HTML;

my $no_data = new_ok 'Spreadsheet::HTML';
is_deeply $no_data->process_data, [ ['&nbsp;'] ],                                       "correct data from interface for no args";
is_deeply Spreadsheet::HTML::process_data(), [ ['&nbsp;'] ],                            "correct data from function for no args";
is $no_data->generate, '<table><tr><th>&nbsp;</th></tr></table>',                       "correct html from function for no args";
is Spreadsheet::HTML::generate(), '<table><tr><th>&nbsp;</th></tr></table>',            "correct html from function for no args";

my $one_string = new_ok 'Spreadsheet::HTML', [ data => 1 ];
is_deeply $one_string->process_data, [ [1] ],                                           "correct data from interface for one scalar string";
is_deeply Spreadsheet::HTML::process_data( 1 ), [ [1] ],                                "correct data from function for one scalar string";
is $one_string->generate, '<table><tr><th>1</th></tr></table>',                         "correct data from function for one scalar string";
is Spreadsheet::HTML::generate( 1 ), '<table><tr><th>1</th></tr></table>',              "correct data from function for one scalar string";

my $oned_empty = new_ok 'Spreadsheet::HTML', [ data => [] ];
is_deeply $oned_empty->process_data, [ ['&nbsp;'] ],                                    "correct data from interface for empty 1d array ref";
is_deeply Spreadsheet::HTML::process_data( [] ), [ ['&nbsp;'] ],                        "correct data from function for empty 1d array ref";
is $oned_empty->generate, '<table><tr><th>&nbsp;</th></tr></table>',                    "correct data from function for empty 3d array ref";
is Spreadsheet::HTML::generate( [] ), '<table><tr><th>&nbsp;</th></tr></table>',        "correct data from function for empty 3d array ref";

my $oned_one_element = new_ok 'Spreadsheet::HTML', [ data => [1] ];
is_deeply $oned_one_element->process_data, [ [1] ],                                     "correct data from interface for 1d array ref with 1 element";
is_deeply Spreadsheet::HTML::process_data( [1] ), [ [1] ],                              "correct data from function for 1d array ref with 1 element";
is $oned_one_element->generate, '<table><tr><th>1</th></tr></table>',                   "correct data from function for 1d array ref with 1 element";
is Spreadsheet::HTML::generate( [1] ), '<table><tr><th>1</th></tr></table>',            "correct data from function for 1d array ref with 1 element";

my $twod_empty = new_ok 'Spreadsheet::HTML', [ data => [ [] ] ];
is_deeply $twod_empty->process_data, [ ['&nbsp;'] ],                                    "correct data from interface for empty 2d array ref";
is_deeply Spreadsheet::HTML::process_data( [ [] ] ), [ ['&nbsp;'] ],                    "correct data from function for empty 2d array ref";
is $twod_empty->generate, '<table><tr><th>&nbsp;</th></tr></table>',                    "correct data from function for empty 2d array ref";
is Spreadsheet::HTML::generate( [ [] ] ), '<table><tr><th>&nbsp;</th></tr></table>',    "correct data from function for empty 2d array ref";

my $one_element = new_ok 'Spreadsheet::HTML', [ data => [ [1] ] ];
is_deeply $one_element->process_data, [ [1] ],                                          "correct data from interface for 2d array ref with one element";
is_deeply Spreadsheet::HTML::process_data( [ [1] ] ), [ [1] ],                          "correct data from function for 2d array ref with one element";
is $one_element->generate, '<table><tr><th>1</th></tr></table>',                        "correct data from function for 2d array ref with one element";
is Spreadsheet::HTML::generate( [ [1] ] ), '<table><tr><th>1</th></tr></table>',        "correct data from function for 2d array ref with one element";

my $data = [
    [ qw( a b c d ) ],
    [ qw( a b c ) ],
    [ qw( a b ) ],
    [ qw( a ) ],
    [ qw( a b c d e f g) ],
];
my $expected = [
    [ ['a'], ['b'], ['c'], ['d'], ],
    [ qw( a b c &nbsp; ) ],
    [ qw( a b &nbsp; &nbsp; ) ],
    [ qw( a &nbsp; &nbsp; &nbsp; ) ],
    [ qw( a b c d e f g) ],
];

my $table = new_ok 'Spreadsheet::HTML', [ data => $data ];
is_deeply [ $table->process_data ], $expected,      "padding is correct";
