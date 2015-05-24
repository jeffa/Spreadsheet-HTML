package Spreadsheet::HTML::YAML;
use strict;
use warnings FATAL => 'all';
our $VERSION = '0.01';

use Carp;
eval "use YAML";
our $NOT_AVAILABLE = $@;

sub load {
    my $file = shift;
    return [[ "cannot load $file" ],[ 'please install YAML' ]] if $NOT_AVAILABLE;

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
