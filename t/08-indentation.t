#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 2;

use Spreadsheet::HTML;

my $data = [
    [qw(a b)],
    [qw(c d)],
];

my $table = Spreadsheet::HTML->new( data => $data );

is $table->generate( indent => '    ' ), 
'<table>
    <tr>
        <th>a</th>
        <th>b</th>
    </tr>
    <tr>
        <td>c</td>
        <td>d</td>
    </tr>
</table>
',  "indentation works";

is $table->generate( indent => '  ', level => 2 ), 
'    <table>
      <tr>
        <th>a</th>
        <th>b</th>
      </tr>
      <tr>
        <td>c</td>
        <td>d</td>
      </tr>
    </table>
',  "level works";
