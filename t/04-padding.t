#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 28;

use Spreadsheet::HTML;

my $no_data = Spreadsheet::HTML->new;
is_deeply scalar $no_data->process, [ [['&nbsp;']] ],                                       "correct data from method for no args";
is_deeply scalar Spreadsheet::HTML::process(), [ [['&nbsp;']] ],                            "correct data from function for no args";
is $no_data->generate, '<table><tr><th>&nbsp;</th></tr></table>',                       "correct html from method for no args";
is Spreadsheet::HTML::generate(), '<table><tr><th>&nbsp;</th></tr></table>',            "correct html from function for no args";

my $one_string = Spreadsheet::HTML->new( data => 1 );
is_deeply scalar $one_string->process, [ [[1]] ],                                           "correct data from method for one scalar string";
is_deeply scalar $one_string->process( matrix => 1 ), [ [1] ],                                           "correct data from method for one scalar string (matrix attr)";
is_deeply scalar Spreadsheet::HTML::process( 1 ), [ [[1]] ],                                "correct data from function for one scalar string";
is $one_string->generate, '<table><tr><th>1</th></tr></table>',                         "correct html from method for one scalar string";
is Spreadsheet::HTML::generate( 1 ), '<table><tr><th>1</th></tr></table>',              "correct html from function for one scalar string";
is Spreadsheet::HTML::generate( data => 1 ), '<table><tr><th>1</th></tr></table>',              "correct html from function for one scalar string";
is Spreadsheet::HTML::generate( data => [ 1 ] ), '<table><tr><th>1</th></tr></table>',              "correct html from function for one scalar string";


my $oned_empty = Spreadsheet::HTML->new( data => [] );
is_deeply scalar $oned_empty->process, [ [['&nbsp;']] ],                                    "correct data from method for empty 1d array ref";
is_deeply scalar Spreadsheet::HTML::process( [] ), [ [['&nbsp;']] ],                        "correct data from function for empty 1d array ref";
is $oned_empty->generate, '<table><tr><th>&nbsp;</th></tr></table>',                    "correct html from method for empty 3d array ref";
is Spreadsheet::HTML::generate( [] ), '<table><tr><th>&nbsp;</th></tr></table>',        "correct html from function for empty 3d array ref";

my $oned_one_element = Spreadsheet::HTML->new( data => [1] );
is_deeply scalar $oned_one_element->process, [ [[1]] ],                                     "correct data from method for 1d array ref with 1 element";
is_deeply scalar Spreadsheet::HTML::process( [1] ), [ [[1]] ],                              "correct data from function for 1d array ref with 1 element";
is $oned_one_element->generate, '<table><tr><th>1</th></tr></table>',                   "correct html from method for 1d array ref with 1 element";
is Spreadsheet::HTML::generate( [1] ), '<table><tr><th>1</th></tr></table>',            "correct html from function for 1d array ref with 1 element";


my $twod_empty = Spreadsheet::HTML->new( data => [ [] ] );
is_deeply scalar $twod_empty->process, [ [['&nbsp;']] ],                                    "correct data from method for empty 2d array ref";
is_deeply scalar Spreadsheet::HTML::process( [ [] ] ), [ [['&nbsp;']] ],                    "correct data from function for empty 2d array ref";
is $twod_empty->generate, '<table><tr><th>&nbsp;</th></tr></table>',                    "correct html from method for empty 2d array ref";
is Spreadsheet::HTML::generate( [ [] ] ), '<table><tr><th>&nbsp;</th></tr></table>',    "correct html from function for empty 2d array ref";

my $one_element = Spreadsheet::HTML->new( data => [ [1] ] );
is_deeply scalar $one_element->process, [ [[1]] ],                                          "correct data from method for 2d array ref with one element";
is_deeply scalar Spreadsheet::HTML::process( [ [1] ] ), [ [[1]] ],                          "correct data from function for 2d array ref with one element";
is $one_element->generate, '<table><tr><th>1</th></tr></table>',                        "correct html from method for 2d array ref with one element";
is Spreadsheet::HTML::generate( [ [1] ] ), '<table><tr><th>1</th></tr></table>',        "correct html from function for 2d array ref with one element";

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
    [ qw( a b c d) ],
];

my $table = Spreadsheet::HTML->new( data => $data );
is_deeply scalar $table->process, $expected, "padding is correct";
