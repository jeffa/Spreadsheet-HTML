#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 30;

use Spreadsheet::HTML;

my $table = Spreadsheet::HTML->new( );

my $layout = '<table border="0" cellpadding="0" cellspacing="0" role="presentation"><tr><td>&nbsp;</td></tr></table>';
is $table->layout, $layout,                          "layout by method";
is Spreadsheet::HTML::layout, $layout,               "layout by procedure";

ok $table->handson,                         "handson by method";
ok Spreadsheet::HTML::handson,              "handson by procedure";

ok $table->checkerboard,                    "checkerboard by method";
ok Spreadsheet::HTML::checkerboard,         "checkerboard by procedure";

my $animate = '<table><caption align="bottom"><button id="toggle" onClick="toggle()">Start</button></caption><tr><th class="animate" id="0-0">&nbsp;</th></tr></table>';
is @{ [ $table->animate ] }[0], $animate,                   "animate by method";
is @{ [ Spreadsheet::HTML::animate ] }[0], $animate,        "animate by procedure";
is @{ [ $table->generate( animate => 1 ) ] }[0], $animate,  "animate by method";
is @{ [ Spreadsheet::HTML::generate( animate => 1 ) ] }[0], $animate, "animate by procedure";

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

ok $table->dk,                              "dk by method";
ok Spreadsheet::HTML::dk,                   "dk by procedure";

ok $table->shroom,                          "shroom by method";
ok Spreadsheet::HTML::shroom,               "shroom by procedure";

ok $table->conway,                          "conway by method";
ok Spreadsheet::HTML::conway,               "conway by procedure";

ok $table->calculator,                      "calculator by method";
ok Spreadsheet::HTML::calculator,           "calculator by procedure";
