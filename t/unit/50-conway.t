#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 6;

use Spreadsheet::HTML;

my $generator = Spreadsheet::HTML->new( sorted_attrs => 1 );

my $html = '<table><caption align="bottom"><button id="toggle" onClick="toggle()">Start</button></caption><tr><th class="conway" height="30px" id="0-0" style="background-color: #EEEEEE" width="30px">&nbsp;</th><th class="conway" height="30px" id="0-1" style="background-color: #EEEEEE" width="30px">&nbsp;</th></tr><tr><td class="conway" height="30px" id="1-0" style="background-color: #EEEEEE" width="30px">&nbsp;</td><td class="conway" height="30px" id="1-1" style="background-color: #EEEEEE" width="30px">&nbsp;</td></tr></table>';

is $html,
    scrub( $generator->conway( fill => '2x2' ) ),
    "2x2 fill conway as method correct";

is $html,
    scrub( Spreadsheet::HTML::conway( fill => '2x2' ) ),
    "2x2 fill conway as procedure correct";

$html = '<table><caption align="bottom"><button id="toggle" onClick="toggle()">Start</button></caption><tr><td class="conway" height="30px" id="0-0" style="background-color: #EEEEEE" width="30px"></td><td class="conway" height="30px" id="0-1" style="background-color: #EEEEEE" width="30px"></td></tr><tr><td class="conway" height="30px" id="1-0" style="background-color: #EEEEEE" width="30px"></td><td class="conway" height="30px" id="1-1" style="background-color: #EEEEEE" width="30px"></td></tr></table>';

is $html,
    scrub( $generator->conway( fill => '2x2', empty => undef, matrix => 1 ) ),
    "2x2 fill conway with empty and matrix as method correct";

is $html,
    scrub( Spreadsheet::HTML::conway( fill => '2x2', empty => undef, matrix => 1 ) ),
    "2x2 fill conway with empty and matrix as procedure correct";

$html = '<table><caption align="bottom"><button id="toggle" onClick="toggle()">Start</button></caption><tr><th class="conway" height="30px" id="0-0" style="background-color: #EEEEEE" width="30px">1</th><th class="conway" height="30px" id="0-1" style="background-color: #EEEEEE" width="30px">2</th></tr><tr><td class="conway" height="30px" id="1-0" style="background-color: #EEEEEE" width="30px">3</td><td class="conway" height="30px" id="1-1" style="background-color: #EEEEEE" width="30px">4</td></tr></table>';

is $html,
    scrub( $generator->conway( data => [1..4], wrap => 2 ) ),
    "2x2 wrapped data conway as method correct";

is $html,
    scrub( Spreadsheet::HTML::conway( data => [1..4], wrap => 2 ) ),
    "2x2 wrapped data conway as procedure correct";



sub scrub {
    $_[0] =~ s/.*?<table/<table/s;
    return $_[0];
}
