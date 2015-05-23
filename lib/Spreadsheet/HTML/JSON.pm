package Spreadsheet::HTML::JSON;
use strict;
use warnings FATAL => 'all';
our $VERSION = '0.00';

use Carp;
use JSON;

sub load {
    my $file = shift;
    open my $fh, '<', $file or croak "Cannot read $file: $!\n";
    my $data = decode_json( do{ local $/; <$fh> } );
    close $fh;
    return $data;
}


1;

__END__
=head1 NAME

Spreadsheet::HTML::JSON - Load data from JSON file.

=head1 METHODS

=over 4

=item load()

=back
