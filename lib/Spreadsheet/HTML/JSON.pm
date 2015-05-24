package Spreadsheet::HTML::JSON;
use strict;
use warnings FATAL => 'all';
our $VERSION = '0.01';

use Carp;
eval "use JSON";
our $NOT_AVAILABLE = $@;

sub load {
    my $file = shift;
    return [[ "cannot load $file" ],[ 'please install JSON' ]] if $NOT_AVAILABLE;

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
