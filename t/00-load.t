#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 2;

use_ok( 'Spreadsheet::HTML' ) or BAIL_OUT( '' );
new_ok 'Spreadsheet::HTML';
