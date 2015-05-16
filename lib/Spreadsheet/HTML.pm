package Spreadsheet::HTML;
use strict;
use warnings FATAL => 'all';
our $VERSION = '0.02';

use Data::Dumper;
use HTML::Entities;

sub new {
    my $class = shift;
    my %attrs = ref($_[0]) eq 'HASH' ? %{+shift} : @_;
    return bless { %attrs }, $class;
}

sub generate {
    my ($self, @data);

    if (ref($_[0]) eq __PACKAGE__) {
        $self = shift;
        @data = $self->get_data;
    } else {
        @data = get_data( @_ );
    }

    return _make_table( @data );
}

sub get_data {
    my ($self, @data);

    if (ref($_[0]) eq __PACKAGE__) {
        # called as method
        $self = shift;
        return @{ $self->{data} } if $self->{__processed_data__};
        @data = @{ ref($self->{data}) ? $self->{data} : [[ $self->{data} ]] };
    } else {
        # called as function
        @data = @_ > 1 ? @_ : @{ ref($_[0]) ? $_[0] : [[ $_[0] ]] };
    }

    @data = [ @data ] unless ref( $data[0] ) eq 'ARRAY';

    $self->{data} = _encode( @data );
    $self->{data} = _mark( $self->{data} );
    $self->{__processed_data__} = 1;
    return @{ $self->{data} };
}

sub _make_table {
    my @data = @_;
    my ($attr, @headers) = @{ shift @data };
    my ($tag) = keys %$attr;
    my $header  = '<tr>';
    $header    .= sprintf( '<%s>%s</%s>', $tag, $_, $tag ) for @headers; 
    $header    .= '</tr>';

    my $rows = '';
    for my $row (@data) {
        my $attr = shift @$row;
        my ($tag) = keys %$attr;
        $rows .= '<tr>';
        $rows .= sprintf( '<%s>%s</%s>', $tag, $row->[$_], $tag ) for 0 .. $#headers;
        $rows .= '</tr>';
    }

    return '<table>' . $header . $rows . '</table>';
}

# TODO: here is where class attrs can be assigned
sub _mark {
    my $data = shift;
    unshift @{ $data->[0] }, { th => {} };
    unshift @{ $data->[$_] }, { td => {} } for 1 .. $#$data;
    return $data;
}


sub _encode {
    my @data = @_;

    # padding is determined by first row (the header)
    my $max_cols = scalar @{ $data[0] || [] };
    for my $row (@data[1 .. $#data]) {
        push @$row, undef for 1 .. ($max_cols - scalar @$row);
    }

    return [
        map { [
            map {
                do { no warnings; s/^\s*$/&nbsp;/g };
                decode_entities( $_ );    
                encode_entities( $_ );    
                s/\n/<br \/>/g;
                $_
            } @$_
        ] } @data
    ];
}

1;

__END__
=head1 NAME

Spreadsheet::HTML - Tabular data to HTML tables.

=head1 SYNOPSIS

  use Spreadsheet::HTML;

  my $table = Spreadsheet::HTML->new( data => 'AoA' );

  print $table->generate;

=head1 METHODS

=over 4

=item new()

=item generate()

=item transpose()

=item get_data()

=back

=head1 AUTHOR

Jeff Anderson, C<< <jeffa at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-spreadsheet-html at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Spreadsheet-HTML>.
I will be notified, and then you'll automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Spreadsheet::HTML

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Spreadsheet-HTML>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Spreadsheet-HTML>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Spreadsheet-HTML>

=item * Search CPAN

L<http://search.cpan.org/dist/Spreadsheet-HTML/>

=back

=head1 ACKNOWLEDGEMENTS

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
