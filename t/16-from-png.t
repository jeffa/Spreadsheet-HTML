#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More;

eval "use Imager::File::PNG";
plan skip_all => "Imager::File::PNG required" if $@;
plan tests => 4;

use_ok 'Spreadsheet::HTML';

my %file = ( file => 't/data/simple.png', sorted_attrs => 1 );
my $html = do { local $/; <DATA> };

my $table = new_ok 'Spreadsheet::HTML', [ %file ];

is $table->generate . $/,
    $html,
    "loaded simple HTML data via method"
;

is Spreadsheet::HTML::generate( %file ) . $/,
    $html,
    "loaded simple HTML data via procedure"
;

__DATA__
<table border="0" cellpadding="0" cellspacing="0"><tr><th height="8" style="background-color: #000000" width="16">&nbsp;</th><th height="8" style="background-color: #000000" width="16">&nbsp;</th><th height="8" style="background-color: #000000" width="16">&nbsp;</th><th height="8" style="background-color: #000000" width="16">&nbsp;</th><th height="8" style="background-color: #000000" width="16">&nbsp;</th><th height="8" style="background-color: #000000" width="16">&nbsp;</th><th height="8" style="background-color: #000000" width="16">&nbsp;</th><th height="8" style="background-color: #000000" width="16">&nbsp;</th></tr><tr><td height="8" style="background-color: #000000" width="16">&nbsp;</td><td height="8" style="background-color: #000000" width="16">&nbsp;</td><td height="8" style="background-color: #000000" width="16">&nbsp;</td><td height="8" style="background-color: #000000" width="16">&nbsp;</td><td height="8" style="background-color: #000000" width="16">&nbsp;</td><td height="8" style="background-color: #000000" width="16">&nbsp;</td><td height="8" style="background-color: #000000" width="16">&nbsp;</td><td height="8" style="background-color: #000000" width="16">&nbsp;</td></tr><tr><td height="8" style="background-color: #000000" width="16">&nbsp;</td><td height="8" style="background-color: #000000" width="16">&nbsp;</td><td height="8" style="background-color: #FF0000" width="16">&nbsp;</td><td height="8" style="background-color: #FF0000" width="16">&nbsp;</td><td height="8" style="background-color: #FF0000" width="16">&nbsp;</td><td height="8" style="background-color: #FF0000" width="16">&nbsp;</td><td height="8" style="background-color: #000000" width="16">&nbsp;</td><td height="8" style="background-color: #000000" width="16">&nbsp;</td></tr><tr><td height="8" style="background-color: #000000" width="16">&nbsp;</td><td height="8" style="background-color: #000000" width="16">&nbsp;</td><td height="8" style="background-color: #FF0000" width="16">&nbsp;</td><td height="8" style="background-color: #FF0000" width="16">&nbsp;</td><td height="8" style="background-color: #FF0000" width="16">&nbsp;</td><td height="8" style="background-color: #FF0000" width="16">&nbsp;</td><td height="8" style="background-color: #000000" width="16">&nbsp;</td><td height="8" style="background-color: #000000" width="16">&nbsp;</td></tr><tr><td height="8" style="background-color: #000000" width="16">&nbsp;</td><td height="8" style="background-color: #000000" width="16">&nbsp;</td><td height="8" style="background-color: #FF0000" width="16">&nbsp;</td><td height="8" style="background-color: #FF0000" width="16">&nbsp;</td><td height="8" style="background-color: #FF0000" width="16">&nbsp;</td><td height="8" style="background-color: #FF0000" width="16">&nbsp;</td><td height="8" style="background-color: #000000" width="16">&nbsp;</td><td height="8" style="background-color: #000000" width="16">&nbsp;</td></tr><tr><td height="8" style="background-color: #000000" width="16">&nbsp;</td><td height="8" style="background-color: #000000" width="16">&nbsp;</td><td height="8" style="background-color: #FF0000" width="16">&nbsp;</td><td height="8" style="background-color: #FF0000" width="16">&nbsp;</td><td height="8" style="background-color: #FF0000" width="16">&nbsp;</td><td height="8" style="background-color: #FF0000" width="16">&nbsp;</td><td height="8" style="background-color: #000000" width="16">&nbsp;</td><td height="8" style="background-color: #000000" width="16">&nbsp;</td></tr><tr><td height="8" style="background-color: #000000" width="16">&nbsp;</td><td height="8" style="background-color: #000000" width="16">&nbsp;</td><td height="8" style="background-color: #000000" width="16">&nbsp;</td><td height="8" style="background-color: #000000" width="16">&nbsp;</td><td height="8" style="background-color: #000000" width="16">&nbsp;</td><td height="8" style="background-color: #000000" width="16">&nbsp;</td><td height="8" style="background-color: #000000" width="16">&nbsp;</td><td height="8" style="background-color: #000000" width="16">&nbsp;</td></tr><tr><td height="8" style="background-color: #000000" width="16">&nbsp;</td><td height="8" style="background-color: #000000" width="16">&nbsp;</td><td height="8" style="background-color: #000000" width="16">&nbsp;</td><td height="8" style="background-color: #000000" width="16">&nbsp;</td><td height="8" style="background-color: #000000" width="16">&nbsp;</td><td height="8" style="background-color: #000000" width="16">&nbsp;</td><td height="8" style="background-color: #000000" width="16">&nbsp;</td><td height="8" style="background-color: #000000" width="16">&nbsp;</td></tr></table>
