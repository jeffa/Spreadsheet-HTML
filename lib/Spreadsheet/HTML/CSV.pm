package Spreadsheet::HTML::CSV;
use strict;
use warnings FATAL => 'all';
our $VERSION = '0.00';

use Carp;
eval "use Text::CSV";

sub load {
    my @data;
    my $file = shift;

    open my $fh, '<', $file or croak "Cannot read $file: $!\n";
    while (<$fh>) {
        chomp;
        push @data, [ split ',', $_ ];
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

=item load()

=back
