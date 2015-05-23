package Spreadsheet::HTML::HTML;
use strict;
use warnings FATAL => 'all';
our $VERSION = '0.00';

use Carp;
eval "use HTML::TableExtract";

sub load {
    my @data;
    my $file = shift;
    my $extract = HTML::TableExtract->new( keep_headers => 1 );
    $extract->parse_file( $file );
    return [ $extract->rows ];
}


1;

__END__
=head1 NAME

Spreadsheet::HTML::HTML - Load data from HTML file.

=head1 METHODS

=over 4

=item load()

=back
