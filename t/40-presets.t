#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 20;

use Spreadsheet::HTML;

my $table = Spreadsheet::HTML->new( data => [[1],[2]] );

ok $table->layout,                          "layout by method";
ok Spreadsheet::HTML::layout,               "layout by procedure";

ok $table->checkerboard,                    "checkerboard by method";
ok Spreadsheet::HTML::checkerboard,         "checkerboard by procedure";

ok $table->animate,                         "animate by method";
ok Spreadsheet::HTML::animate,              "animate by procedure";

ok $table->generate( animate => 1 ),            "animate by method";
ok Spreadsheet::HTML::generate( animate => 1 ), "animate by procedure";

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
