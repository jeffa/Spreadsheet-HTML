package Spreadsheet::HTML::YAML;
use strict;
use warnings FATAL => 'all';
our $VERSION = '0.00';

use Carp;
eval "use YAML";

sub load {
    my $file = shift;
    my $data = YAML::LoadFile( $file );
    return $data;
}


1;

__END__
=head1 NAME

Spreadsheet::HTML::YAML - Load data from YAML file.

=head1 METHODS

=over 4

=item load()

=back
