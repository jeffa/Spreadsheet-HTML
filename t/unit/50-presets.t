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

ok $table->list,                            "list by method";
ok Spreadsheet::HTML::list,                 "list by procedure";

ok $table->select,                          "select by method";
ok Spreadsheet::HTML::select,               "select by procedure";

ok $table->handson,                         "handson by method";
ok Spreadsheet::HTML::handson,              "handson by procedure";

ok $table->checkerboard,                    "checkerboard by method";
ok Spreadsheet::HTML::checkerboard,         "checkerboard by procedure";

my $scroll = '<table><caption align="bottom"><button id="toggle" onClick="toggle()">Start</button></caption><tr><th class="scroll" id="0-0">&nbsp;</th></tr></table>';
is scrub_js( @{ [ $table->scroll ] }[0] ), $scroll,                                       "scroll by method";
is scrub_js( @{ [ Spreadsheet::HTML::scroll( %attr ) ] }[0] ), $scroll,                   "scroll by procedure";
is scrub_js( @{ [ $table->generate( scroll => 1 ) ] }[0] ), $scroll,                      "scroll by method";
is scrub_js( @{ [ Spreadsheet::HTML::generate( scroll => 1, %attr ) ] }[0] ), $scroll,    "scroll by procedure";

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

ok $table->calculator,                      "calculator by method";
ok Spreadsheet::HTML::calculator,           "calculator by procedure";

sub scrub_js {
    my $str = shift;
    $str =~ s/.*<\/script>//s;
    return $str;
}
