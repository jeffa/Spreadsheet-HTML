package Spreadsheet::HTML::CSV;
use strict;
use warnings FATAL => 'all';
our $VERSION = '0.01';
use Carp;

our $PARSER = '';
eval "use Text::CSV_XS";
if ($@) {
    eval "use Text::CSV";
    $PARSER = 'Text::CSV' unless $@;
} else {
    $PARSER = 'Text::CSV_XS';
}

sub load {
    my @data;
    my $file = shift;

    open my $fh, '<', $file or croak "Cannot read $file: $!\n";

    if ($PARSER) {
        my $csv = $PARSER->new;
        while (my $row = $csv->getline( $fh )) {
            push @data, $row;
        }

    } else {

        while (<$fh>) {
            chomp;
            push @data, [ split /\s*,\s*/, $_ ];
        }
    }

    close $fh;
    return [ @data ];
}


1;

__END__
=head1 NAME

Spreadsheet::HTML::CSV - Load data from CSV file.

=head1 METHODS

=over 4

=item * load()

Attempts to first load L<Text::CSV_XS> then L<Text::CSV> if the former
is not installed. If neither are installed attempts to parse CSV file
using a very simple (and brittle) method.

=back
