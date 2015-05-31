#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 8;
use Data::Dumper;

use Spreadsheet::HTML;

my $data = [ map [qw(foo1 bar1 baz1 qux1)], 1 .. 100 ];

my $table = Spreadsheet::HTML->new( data => $data );

is $table->generate, $table->portrait,                                                  "portrait emits same as generate" ;
is Spreadsheet::HTML::generate( $data ), Spreadsheet::HTML::portrait( $data ),          "portrait emits same as generate" ;
is $table->transpose, $table->landscape,                                                "landscape emits same as transpose" ;
is Spreadsheet::HTML::transpose( $data ), Spreadsheet::HTML::landscape( $data ),        "landscape emits same as transpose" ;

my @args = ( indent => "\t", table => { class => "generated" }, tr => { class => "even" } );
is $table->generate( @args ), $table->portrait( @args ),                                                        "portrait emits same as generate (with args)" ;
is Spreadsheet::HTML::generate( data => $data, @args ), Spreadsheet::HTML::portrait( data => $data, @args ),    "portrait emits same as generate (with args)" ;
is $table->transpose( @args ), $table->landscape( @args ),                                                      "landscape emits same as transpose (with args)" ;
is Spreadsheet::HTML::transpose( data => $data, @args ), Spreadsheet::HTML::landscape( data => $data, @args ),  "landscape emits same as transpose (with args)" ;
