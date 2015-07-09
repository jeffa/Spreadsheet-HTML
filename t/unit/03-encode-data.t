#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 12;

use Spreadsheet::HTML;

my $encodes = [
    [ qw( < = & > " ' ) ],
    [ qw( < = & > " ' ) ],
];
my $spaces = [
    [ "\n", "foo\n", " ", " \n" ],
    [ "\n", "foo\n", " ", " \n" ],
];

my $expected_encodes = [
    [ map { tag => 'th', cdata => $_ }, qw( < = & > " ' ) ],
    [ map { tag => 'td', cdata => $_ }, qw( < = & > " ' ) ],
];
my $expected_spaces = [
    [ map { tag => 'th', cdata => $_ }, '&nbsp;', "foo\n", '&nbsp;', '&nbsp;' ],
    [ map { tag => 'td', cdata => $_ }, '&nbsp;', "foo\n", '&nbsp;', '&nbsp;' ],
];

my $table = Spreadsheet::HTML->new( data => $encodes );
is_deeply scalar $table->_process, $expected_encodes,  "we are not encoding data by default";
is_deeply scalar $table->_process, $expected_encodes,  "only processes once";

is $table->generate(),
    q(<table><tr><th><</th><th>=</th><th>&</th><th>></th><th>"</th><th>'</th></tr><tr><td><</td><td>=</td><td>&</td><td>></td><td>"</td><td>'</td></tr></table>),
    "no HTML entities encoded";

is $table->generate( encodes => '<=&>' ),
    q(<table><tr><th>&lt;</th><th>&#61;</th><th>&amp;</th><th>&gt;</th><th>"</th><th>'</th></tr><tr><td>&lt;</td><td>&#61;</td><td>&amp;</td><td>&gt;</td><td>"</td><td>'</td></tr></table>),
    "encoding certain HTML entities";

is $table->generate( encodes => '<=&>"\'' ),
    '<table><tr><th>&lt;</th><th>&#61;</th><th>&amp;</th><th>&gt;</th><th>&quot;</th><th>&#39;</th></tr><tr><td>&lt;</td><td>&#61;</td><td>&amp;</td><td>&gt;</td><td>&quot;</td><td>&#39;</td></tr></table>',
    "encoding some more HTML entities";

is $table->generate( encodes => undef ),
    '<table><tr><th>&lt;</th><th>=</th><th>&amp;</th><th>&gt;</th><th>&quot;</th><th>&#39;</th></tr><tr><td>&lt;</td><td>=</td><td>&amp;</td><td>&gt;</td><td>&quot;</td><td>&#39;</td></tr></table>',
    "encoding all HTML entities";

$table = Spreadsheet::HTML->new( data => $spaces );
is_deeply scalar $table->_process, $expected_spaces,  "correctly substituted spaces";
is_deeply scalar $table->_process, $expected_spaces,  "only processes once";

$expected_spaces = [
    [ map { tag => 'th', cdata => $_ }, '', "foo\n", '', '' ],
    [ map { tag => 'td', cdata => $_ }, '', "foo\n", '', '' ],
];
$table = Spreadsheet::HTML->new( data => $spaces, empty => undef );
is_deeply scalar $table->_process, $expected_spaces,  "spaces untouched";

$expected_spaces = [
    [ map { tag => 'th', cdata => $_ }, '', "foo\n", '', '' ],
    [ map { tag => 'td', cdata => $_ }, '', "foo\n", '', '' ],
];
$table = Spreadsheet::HTML->new( data => $spaces, empty => '' );
is_deeply scalar $table->_process, $expected_spaces,  "correctly substituted spaces";

$expected_spaces = [
    [ map { tag => 'th', cdata => $_ }, ' ', "foo\n", ' ', ' ' ],
    [ map { tag => 'td', cdata => $_ }, ' ', "foo\n", ' ', ' ' ],
];
$table = Spreadsheet::HTML->new( data => $spaces, empty => ' ' );
is_deeply scalar $table->_process, $expected_spaces,  "correctly substituted spaces";

$expected_spaces = [
    [ map { tag => 'th', cdata => $_ }, 0, "foo\n", 0, 0 ],
    [ map { tag => 'td', cdata => $_ }, 0, "foo\n", 0, 0 ],
];
$table = Spreadsheet::HTML->new( data => $spaces, empty => 0 );
is_deeply scalar $table->_process, $expected_spaces,  "correctly substituted spaces";