#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More;

eval "use Spreadsheet::Engine";
plan skip_all => "Spreadsheet::Engine required" if $@;
plan tests => 1;

use Spreadsheet::HTML;

my $table = Spreadsheet::HTML->new(
    data => [
        [ qw( Name Age Id ) ],
        [ qw( Bob 20 1 ) ],
        [ qw( Mary 30 2 ) ],
        [ qw( Lary 27 3 ) ],
        [ qw( Sue 50 4 ) ],
    ],
);

is $table->generate( execute => 'set B6 formula SUM(B2:B5)' ),
    '<table><tr><th>Name</th><th>Age</th><th>Id</th></tr><tr><td>Bob</td><td>20</td><td>1</td></tr><tr><td>Mary</td><td>30</td><td>2</td></tr><tr><td>Lary</td><td>27</td><td>3</td></tr><tr><td>Sue</td><td>50</td><td>4</td></tr><tr><td>&nbsp;</td><td>127</td><td>&nbsp;</td></tr></table>',
    "correct output for SUM";


