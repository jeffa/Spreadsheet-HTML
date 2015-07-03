#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 4;

use Spreadsheet::HTML;

my $data = [ 1 .. 8 ];
my $table = Spreadsheet::HTML->new( data => $data, wrap => 3 );
is $table->generate, 
    '<table><tr><th>1</th><th>2</th><th>3</th></tr><tr><td>4</td><td>5</td><td>6</td></tr><tr><td>7</td><td>8</td><td>&nbsp;</td></tr></table>',
    "correctly wrapped 1D array (method)";

is Spreadsheet::HTML::generate( data => $data, wrap => 3 ), 
    '<table><tr><th>1</th><th>2</th><th>3</th></tr><tr><td>4</td><td>5</td><td>6</td></tr><tr><td>7</td><td>8</td><td>&nbsp;</td></tr></table>',
    "correctly wrapped 1D array (procedural)";

$data = [ [1,2], [3,4], [5,6], [7,8] ];
$table = Spreadsheet::HTML->new( data => $data, wrap => 3 );
is $table->generate, 
    '<table><tr><th>1</th><th>2</th><th>3</th></tr><tr><td>4</td><td>5</td><td>6</td></tr><tr><td>7</td><td>8</td><td>&nbsp;</td></tr></table>',
    "correctly re-wrapped 2D array (method)";

is Spreadsheet::HTML::generate( data => $data, wrap => 3 ), 
    '<table><tr><th>1</th><th>2</th><th>3</th></tr><tr><td>4</td><td>5</td><td>6</td></tr><tr><td>7</td><td>8</td><td>&nbsp;</td></tr></table>',
    "correctly re-wrapped 2D array (procedural)";
