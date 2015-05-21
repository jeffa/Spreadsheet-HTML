#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 2;

use_ok 'Spreadsheet::HTML';
new_ok 'Spreadsheet::HTML';
