package Spreadsheet::HTML::File::Loader;
use Carp;
use strict;
use warnings FATAL => 'all';

eval "use Spreadsheet::Read";
our $NOT_AVAILABLE = $@;

sub parse {
    my $args     = shift;
    my $file     = $args->{file};
    my $preserve = $args->{preserve};

    if ($file =~ /\.html?$/) {
        return Spreadsheet::HTML::File::HTML::parse( $args );
    } elsif ($file =~ /\.jso?n$/) {
        return Spreadsheet::HTML::File::JSON::parse( $args );
    } elsif ($file =~ /\.ya?ml$/) {
        return Spreadsheet::HTML::File::YAML::parse( $args );
    }

    return [[ "cannot load $file" ],[ 'No such file or directory' ]] unless -r $file;
    return [[ "cannot load $file" ],[ 'please install Spreadsheet::Read' ]] if $NOT_AVAILABLE;

    my $workbook = ReadData( $file, attr => $preserve, clip => 0 );
    my $parsed   = $workbook->[ $args->{worksheet} ];

    if ($preserve and ref $parsed->{attr} eq 'ARRAY' and scalar@{$parsed->{attr}}) {

        my %attr_map = _attr_map();
        for my $row (1 .. $#{ $parsed->{attr} }) {
            for my $col (1 .. $#{ $parsed->{attr}[$row] }) {
                my $attr = $parsed->{attr}[$row][$col];
                my %styles;
                for my $key (keys %$attr) {
                    my $map = $attr_map{$key};
                    next unless $map and $attr->{$key};
                    if ($map->[0]) {
                        $styles{$map->[1]} = $map->[2];
                    } else {
                        $styles{$map->[1]} = $attr->{$key};
                    }
                }
                $args->{ sprintf '-r%sc%s', $col - 1, $row - 1 } = { style => { %styles } };
            }
        }
    }

    return [ Spreadsheet::Read::rows( $parsed ) ];
}

sub _attr_map {(
    font        => [ 0, 'font-family' ],
    size        => [ 0, 'font-size' ],
    valign      => [ 0, 'vertical-align' ],
    halign      => [ 0, 'text-align' ],
    fgcolor     => [ 0, 'color' ],
    bgcolor     => [ 0, 'background-color' ],
    bold        => [ 1, 'font-weight', 'bold' ],
    uline       => [ 1, 'text-decoration', 'underline' ],
    italic      => [ 1, 'font-style', 'italic' ],
    hidden      => [ 1, 'display', 'none' ],
)}

=head1 NAME

Spreadsheet::HTML::File::Loader - Load data from files.

=head1 SUPPORTED FORMATS

=over 4

=item * CSV/XLS

Parses with L<Spreadsheet::Read>.

=item * HTML

Parses with L<HTML::TableExtract>.

=item * JSON

Parses with L<JSON>.

=item * YAML

Parses with L<YAML>.

=back

=head1 BEGIN REQUISITE DOCUMENTATION

The rest of this document exists to make POD tests happy. 

You may stop reading now :)

=head1 METHODS

=over 4

=item * C<parse( \%args )>

=back

=cut

1;



package Spreadsheet::HTML::File::YAML;
=head1 NAME

Spreadsheet::HTML::File::YAML - Load data from YAML encoded data files.

=head1 METHODS

=over 4

=item * C<parse( \%args )>

=back

=head1 REQUIRES

=over 4

=item * L<YAML>

=back

=cut

use Carp;
use strict;
use warnings FATAL => 'all';

eval "use YAML";
our $NOT_AVAILABLE = $@;

sub parse {
    my $args = shift;
    my $file = $args->{file};
    return [[ "cannot load $file" ],[ 'No such file or directory' ]] unless -r $file;
    return [[ "cannot load $file" ],[ 'please install YAML' ]] if $NOT_AVAILABLE;

    my $data = YAML::LoadFile( $file );
    return $data;
}

1;



package Spreadsheet::HTML::File::JSON;
=head1 NAME

Spreadsheet::HTML::File::JSON - Load data from JSON encoded data files.

=head1 METHODS

=over 4

=item * C<parse( \%args )>

=back

=head1 REQUIRES

=over 4

=item * L<JSON>

=back

=cut

use Carp;
use strict;
use warnings FATAL => 'all';

eval "use JSON";
our $NOT_AVAILABLE = $@;

sub parse {
    my $args = shift;
    my $file = $args->{file};
    return [[ "cannot load $file" ],[ 'No such file or directory' ]] unless -r $file;
    return [[ "cannot load $file" ],[ 'please install JSON' ]] if $NOT_AVAILABLE;

    open my $fh, '<', $file or return [[ "cannot load $file" ],[ $! ]];
    my $data = decode_json( do{ local $/; <$fh> } );
    close $fh;
    return $data;
}

1;



package Spreadsheet::HTML::File::HTML;
=head1 NAME

Spreadsheet::HTML::File::HTML - Load data from Hypertext Markup files.

=head1 METHODS

=over 4

=item * C<parse( \%args )>

=back

=head1 REQUIRES

=over 4

=item * L<HTML::TableExtract>

=back

=cut

use Carp;
use strict;
use warnings FATAL => 'all';

eval "use HTML::TableExtract";
our $NOT_AVAILABLE = $@;

sub parse {
    my $args = shift;
    my $file = $args->{file};
    return [[ "cannot load $file" ],[ 'No such file or directory' ]] unless -r $file;
    return [[ "cannot load $file" ],[ 'please install HTML::TableExtract' ]] if $NOT_AVAILABLE;

    my @data;
    my $extract = HTML::TableExtract->new( keep_headers => 1 );
    $extract->parse_file( $file );
    my $table = ($extract->tables)[ $args->{worksheet} - 1 ];
    return [ $table ? $table->rows : [undef] ];
}

1;



=head1 AUTHOR

Jeff Anderson, C<< <jeffa at cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright 2015 Jeff Anderson.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=cut

1;
