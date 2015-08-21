#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 30;

use Spreadsheet::HTML;

my %attr  = ( sorted_attrs => 1 );
my $table = Spreadsheet::HTML->new( %attr );

my $layout = '<table border="0" cellpadding="0" cellspacing="0" role="presentation"><tr><td>&nbsp;</td></tr></table>';
is $table->layout, $layout,                          "layout by method";
is Spreadsheet::HTML::layout( %attr ), $layout,      "layout by procedure";

ok $table->handson,                         "handson by method";
ok Spreadsheet::HTML::handson,              "handson by procedure";

ok $table->checkerboard,                    "checkerboard by method";
ok Spreadsheet::HTML::checkerboard,         "checkerboard by procedure";

my $animate = '<table><caption align="bottom"><button id="toggle" onClick="toggle()">Start</button></caption><tr><th class="animate" id="0-0">&nbsp;</th></tr></table>';
is scrub_js( @{ [ $table->animate ] }[0] ), $animate,                                       "animate by method";
is scrub_js( @{ [ Spreadsheet::HTML::animate( %attr ) ] }[0] ), $animate,                   "animate by procedure";
is scrub_js( @{ [ $table->generate( animate => 1 ) ] }[0] ), $animate,                      "animate by method";
is scrub_js( @{ [ Spreadsheet::HTML::generate( animate => 1, %attr ) ] }[0] ), $animate,    "animate by procedure";

ok $table->banner,                          "banner by method";
ok Spreadsheet::HTML::banner,               "banner by procedure";

ok $table->calendar,                        "calendar by method";
ok Spreadsheet::HTML::calendar,             "calendar by procedure";

ok $table->sudoku( attempts => 0 ),             "sudoku by method";
ok Spreadsheet::HTML::sudoku( attempts => 0 ),  "sudoku by procedure";

ok $table->maze,                            "maze by method";
ok Spreadsheet::HTML::maze,                 "maze by procedure";

ok $table->checkers,                        "checkers by method";
ok Spreadsheet::HTML::checkers,             "checkers by procedure";

ok $table->chess,                           "chess by method";
ok Spreadsheet::HTML::chess,                "chess by procedure";

ok $table->tictactoe,                       "tictactoe by method";
ok Spreadsheet::HTML::tictactoe,            "tictactoe by procedure";

ok $table->beadwork,                        "beadwork by method";
ok Spreadsheet::HTML::beadwork,             "beadwork by procedure";

ok $table->conway,                          "conway by method";
ok Spreadsheet::HTML::conway,               "conway by procedure";

ok $table->calculator,                      "calculator by method";
ok Spreadsheet::HTML::calculator,           "calculator by procedure";

sub scrub_js {
    my $str = shift;
    $str =~ s/.*<\/script>//s;
    return $str;
}
