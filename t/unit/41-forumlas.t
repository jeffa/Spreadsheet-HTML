#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More;

eval "use Spreadsheet::Engine";
plan skip_all => "Spreadsheet::Engine required" if $@;
plan tests => 2;

use Spreadsheet::HTML;

my $table = Spreadsheet::HTML->new(
    data => [
        [ qw( Name Foo Bar Baz ) ],
        [ qw( Bob 20 80 50 ) ],
        [ qw( Mary 30 50 40 ) ],
        [ qw( Lary 20 30 20 ) ],
        [ qw( Sue 50 20 30 ) ],
    ],
);

is $table->generate( apply => 'set B6 formula SUM(B2:B5)' ),
    '<table><tr><th>Name</th><th>Foo</th><th>Bar</th><th>Baz</th></tr><tr><td>Bob</td><td>20</td><td>80</td><td>50</td></tr><tr><td>Mary</td><td>30</td><td>50</td><td>40</td></tr><tr><td>Lary</td><td>20</td><td>30</td><td>20</td></tr><tr><td>Sue</td><td>50</td><td>20</td><td>30</td></tr><tr><td>&nbsp;</td><td>120</td><td>&nbsp;</td><td>&nbsp;</td></tr></table>',
    "correct output for one SUM";

is $table->generate( apply => [ 'set C6 formula SUM(C2:C5)', 'set D6 formula SUM(D2:D5)' ] ),
    '<table><tr><th>Name</th><th>Foo</th><th>Bar</th><th>Baz</th></tr><tr><td>Bob</td><td>20</td><td>80</td><td>50</td></tr><tr><td>Mary</td><td>30</td><td>50</td><td>40</td></tr><tr><td>Lary</td><td>20</td><td>30</td><td>20</td></tr><tr><td>Sue</td><td>50</td><td>20</td><td>30</td></tr><tr><td>&nbsp;</td><td>&nbsp;</td><td>180</td><td>140</td></tr></table>',
    "correct output for multiple SUMs";
