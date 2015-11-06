package Spreadsheet::HTML::Presets::List;
use strict;
use warnings FATAL => 'all';

sub list {
    my ($self,$data,$args);
    $self = shift if ref($_[0]) =~ /^Spreadsheet::HTML/;
    ($self,$data,$args) = $self ? $self->_args( @_ ) : Spreadsheet::HTML::_args( @_ );

    my $list = [];
    if (exists $args->{col}) {
        $args->{col} = 0 unless $args->{col} =~ /^\d+$/;
        $list = [ map { $data->[$_][$args->{col}] } 0 .. $#$data ];
    } else {
        $args->{row} = 0 unless $args->{row} && $args->{row} =~ /^\d+$/;
        $list = @$data[$args->{row}];
    }

    my $empty = exists $args->{empty} ? $args->{empty} : '&nbsp;';

    return $args->{_auto}->tag(
        tag   => $args->{ordered} ? 'ol' : 'ul', 
        attr  => $args->{ol} || $args->{ul},
        cdata => [
            map {
                my ( $cdata, $attr ) = Spreadsheet::HTML::_extrapolate( $_, undef, $args->{li} );
                do{ no warnings;
                    $cdata = HTML::Entities::encode_entities( $cdata, $args->{encodes} ) if $args->{encode} || exists $args->{encodes};
                    $cdata =~ s/^\s*$/$empty/g;
                };
                { tag => 'li', attr => $attr, cdata => $cdata }
            } @$list
        ]
    );
}

=head1 NAME

Spreadsheet::HTML::Presets::List - Generate ordered and unordered HTML lists.

=head1 DESCRIPTION

This is a container for L<Spreadsheet::HTML> preset methods.
These methods are not meant to be called from this package.
Instead, use the Spreadsheet::HTML interface:

  use Spreadsheet::HTML;
  my $generator = Spreadsheet::HTML->new( data => \@data );
  print $generator->list( ordered => 1 );

  # or
  use Spreadsheet::HTML qw( list );
  print list( data => \@data, col => 2 );

=head1 METHODS

=over 4

=item C<list()>

=back

=head2 LITERAL PARAMETERS

=over 4

=item C<ordered>

Uses <ol> instead of <ul> container when true.

=item C<row>

Emit this row. Default 0. (Zero index based.)

=item C<col>

Emit this column. Default 0. (Zero index based.)

=back

=head2 TAG PARAMETERS

=over 4

=item C<ol>

Hash reference of attributes.

=item C<ul>

Hash reference of attributes.

=item C<li>

Accepts hash reference, sub reference, or array ref containing either or both.

=back

=head1 SEE ALSO

=over 4

=item L<Spreadsheet::HTML>

The interface for this functionality.

=item L<Spreadsheet::HTML::Presets>

More presets.

=back

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
