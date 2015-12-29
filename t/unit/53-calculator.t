#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 2;

use Spreadsheet::HTML;

my $generator = Spreadsheet::HTML->new( sorted_attrs => 1 );

my $html = q{<table style="border: thick outset; margins: 0; padding: 0;" width="20%"><caption><input id="display" style="background-color: #F1FACA; height: 8%; width: 80%; text-align: right; font-size: xx-large; font-weight: bold; font-family: monospace;" /></caption><tr><td align="center" height="65" style="font-size: xx-large; margins: 0; padding: 0;" width="65"><button style="width: 100%; height: 100%; font-size: xx-large; font-weight: bold; font-family: monospace;">C</button></td><td align="center" height="65" style="font-size: xx-large; margins: 0; padding: 0;" width="65"><button style="width: 100%; height: 100%; font-size: xx-large; font-weight: bold; font-family: monospace;">&plusmn;</button></td><td align="center" height="65" style="font-size: xx-large; margins: 0; padding: 0;" width="65"><button style="width: 100%; height: 100%; font-size: xx-large; font-weight: bold; font-family: monospace;">&divide;</button></td><td align="center" height="65" style="font-size: xx-large; margins: 0; padding: 0;" width="65"><button style="width: 100%; height: 100%; font-size: xx-large; font-weight: bold; font-family: monospace;">&times;</button></td></tr><tr><td align="center" height="65" style="font-size: xx-large; margins: 0; padding: 0;" width="65"><button style="width: 100%; height: 100%; font-size: xx-large; font-weight: bold; font-family: monospace;">7</button></td><td align="center" height="65" style="font-size: xx-large; margins: 0; padding: 0;" width="65"><button style="width: 100%; height: 100%; font-size: xx-large; font-weight: bold; font-family: monospace;">8</button></td><td align="center" height="65" style="font-size: xx-large; margins: 0; padding: 0;" width="65"><button style="width: 100%; height: 100%; font-size: xx-large; font-weight: bold; font-family: monospace;">9</button></td><td align="center" height="65" style="font-size: xx-large; margins: 0; padding: 0;" width="65"><button style="width: 100%; height: 100%; font-size: xx-large; font-weight: bold; font-family: monospace;">&minus;</button></td></tr><tr><td align="center" height="65" style="font-size: xx-large; margins: 0; padding: 0;" width="65"><button style="width: 100%; height: 100%; font-size: xx-large; font-weight: bold; font-family: monospace;">4</button></td><td align="center" height="65" style="font-size: xx-large; margins: 0; padding: 0;" width="65"><button style="width: 100%; height: 100%; font-size: xx-large; font-weight: bold; font-family: monospace;">5</button></td><td align="center" height="65" style="font-size: xx-large; margins: 0; padding: 0;" width="65"><button style="width: 100%; height: 100%; font-size: xx-large; font-weight: bold; font-family: monospace;">6</button></td><td align="center" height="65" style="font-size: xx-large; margins: 0; padding: 0;" width="65"><button style="width: 100%; height: 100%; font-size: xx-large; font-weight: bold; font-family: monospace;">+</button></td></tr><tr><td align="center" height="65" style="font-size: xx-large; margins: 0; padding: 0;" width="65"><button style="width: 100%; height: 100%; font-size: xx-large; font-weight: bold; font-family: monospace;">1</button></td><td align="center" height="65" style="font-size: xx-large; margins: 0; padding: 0;" width="65"><button style="width: 100%; height: 100%; font-size: xx-large; font-weight: bold; font-family: monospace;">2</button></td><td align="center" height="65" style="font-size: xx-large; margins: 0; padding: 0;" width="65"><button style="width: 100%; height: 100%; font-size: xx-large; font-weight: bold; font-family: monospace;">3</button></td><td align="center" height="65" rowspan="2" style="font-size: xx-large; margins: 0; padding: 0;" width="65"><button style="width: 100%; height: 100%; font-size: xx-large; font-weight: bold; font-family: monospace;">=</button></td></tr><tr><td align="center" colspan="2" height="65" style="font-size: xx-large; margins: 0; padding: 0;" width="65"><button style="width: 100%; height: 100%; font-size: xx-large; font-weight: bold; font-family: monospace;">0</button></td><td align="center" height="65" style="font-size: xx-large; margins: 0; padding: 0;" width="65"><button style="width: 100%; height: 100%; font-size: xx-large; font-weight: bold; font-family: monospace;">.</button></td></tr></table>};

is $html,
    scrub( $generator->calculator() ),
    "calculator as method correct";

is $html,
    scrub( Spreadsheet::HTML::calculator() ),
    "calculator as function correct";



sub scrub {
    $_[0] =~ s/.*?<table/<table/s;
    return $_[0];
}
