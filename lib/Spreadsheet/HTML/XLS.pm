package Spreadsheet::HTML::XLS;
use strict;
use warnings FATAL => 'all';
our $VERSION = '0.01';

use Carp;
eval "use Spreadsheet::ParseExcel";
our $NOT_AVAILABLE = $@;

sub load {
    my $file = shift;
    return [[ "cannot load $file" ],[ 'please install Spreadsheet::ParseExcel' ]] if $NOT_AVAILABLE;

    my $parser   = Spreadsheet::ParseExcel->new;
    my $workbook = $parser->parse( $file );
    return [[ "cannot load $file" ],[ $parser->error ]] unless defined $workbook;

    # can only handle first worksheet found for now
    my ($worksheet) = $workbook->worksheets;
    my ( $row_min, $row_max ) = $worksheet->row_range;
    my ( $col_min, $col_max ) = $worksheet->col_range;
     
    my @data;
    for my $row ( $row_min .. $row_max ) {
        my @row;
        for my $col ( $col_min .. $col_max ) {
            my $cell = $worksheet->get_cell( $row, $col );
            next unless $cell;
            push @row, $cell ? $cell->unformatted : undef;
        }
        push @data, [@row];
    }

    return [ @data ];
}


1;

__END__
=head1 NAME

Spreadsheet::HTML::XLS - Load data from HTML file.

=head1 METHODS

=over 4

=item load()

=back
