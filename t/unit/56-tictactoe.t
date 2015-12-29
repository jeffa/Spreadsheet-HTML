#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 2;

use Spreadsheet::HTML;

my $generator = Spreadsheet::HTML->new( sorted_attrs => 1 );

my $html = '<table id="tictactoe" style="font-family: cursive, sans-serif; font-size: xx-large;"><tr><td align="center" height="100" width="100">&nbsp;</td><td align="center" height="100" style="border-left:1px solid black; border-right:1px  solid black;" width="100">&nbsp;</td><td align="center" height="100" width="100">&nbsp;</td></tr><tr><td align="center" height="100" style="border-top:1px  solid black; border-bottom:1px solid black;" width="100">&nbsp;</td><td align="center" height="100" style="border-left:1px solid black; border-right:1px  solid black; border-top:1px solid black; border-bottom:1px solid black;" width="100">&nbsp;</td><td align="center" height="100" style="border-top:1px  solid black; border-bottom:1px solid black;" width="100">&nbsp;</td></tr><tr><td align="center" height="100" width="100">&nbsp;</td><td align="center" height="100" style="border-left:1px solid black; border-right:1px  solid black;" width="100">&nbsp;</td><td align="center" height="100" width="100">&nbsp;</td></tr></table>';

is scrub( $generator->tictactoe() ),
    $html,
    "tictactoe as method correct";

is scrub( Spreadsheet::HTML::tictactoe( sorted_attrs => 1 ) ),
    $html,
    "tictactoe as function correct";

sub scrub {
    $_[0] =~ s/.*?<table/<table/s;
    return $_[0];
}
