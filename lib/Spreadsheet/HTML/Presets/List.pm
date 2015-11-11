package Spreadsheet::HTML::Presets::List;
use strict;
use warnings FATAL => 'all';

sub list {
    my ($self,$data,$args);
    $self = shift if ref($_[0]) =~ /^Spreadsheet::HTML/;
    ($self,$data,$args) = $self ? $self->_args( @_ ) : Spreadsheet::HTML::_args( @_ );

    my $list = [];
    if (exists $args->{row}) {
        $args->{row} = 0 unless $args->{row} =~ /^\d+$/;
        $list = @$data[$args->{row}];
    } else {
        $args->{col} = 0 unless $args->{col} && $args->{col} =~ /^\d+$/;
        $list = [ map { $data->[$_][$args->{col}] } 0 .. $#$data ];
    }

    $HTML::AutoTag::ENCODE  = defined $args->{encode}  ? $args->{encode}  : exists $args->{encodes};
    $HTML::AutoTag::ENCODES = defined $args->{encodes} ? $args->{encodes} : '';
    return $args->{_auto}->tag(
        tag   => $args->{ordered} ? 'ol' : 'ul', 
        attr  => $args->{ol} || $args->{ul},
        cdata => [
            map {
                my ( $cdata, $attr ) = Spreadsheet::HTML::_extrapolate( $_, undef, $args->{li} );
                { tag => 'li', attr => $attr, cdata => $cdata }
            } @$list
        ]
    );
}

sub select {
    my ($self,$data,$args);
    $self = shift if ref($_[0]) =~ /^Spreadsheet::HTML/;
    ($self,$data,$args) = $self ? $self->_args( @_ ) : Spreadsheet::HTML::_args( @_ );

    my $texts  = [];
    my $values = [];
    if (exists $args->{row}) {
        $args->{row} = 0 unless $args->{row} =~ /^\d+$/;
        $texts  = @$data[$args->{row}];
        $values = @$data[$args->{row} + 1];
    } else {
        $args->{col} = 0 unless $args->{col} && $args->{col} =~ /^\d+$/;
        $texts  = [ map { $data->[$_][$args->{col}] } 0 .. $#$data ];
        $values = [ map { $data->[$_][$args->{col} + 1 ] } 0 .. $#$data ];
    }

    my $selected = [];
    if ($args->{texts}) {
        $args->{texts} = [ $args->{texts} ] unless ref $args->{texts};
        for my $text (@$texts) {
            if (grep $_ eq $text, @{ $args->{texts} }) {
                push @$selected, 'selected';
            } else {
                push @$selected, undef;
            }
        }
    } elsif ($args->{values}) {
        $args->{values} = [ $args->{values} ] unless ref $args->{values};
        for my $value (@$values) {
            if (grep $_ eq $value, @{ $args->{values} }) {
                push @$selected, 'selected';
            } else {
                push @$selected, undef;
            }
        }
    }

    my $placeholder;
    if ($args->{placeholder}) {
        $placeholder = { tag => 'option', attr => { value => '' }, cdata => $args->{placeholder} };
    }

    my $attr = {};
    $attr->{value}    = $texts   if $args->{labels};
    $attr->{selected} = $selected if map defined $_ ? $_ : (), @$selected;

    my $options = [ map { { tag => 'option', attr => $attr, cdata => $_ } } $args->{labels} ? @$values : @$texts ];

    if (ref( $args->{optgroup} ) eq 'ARRAY' and @{ $args->{optgroup} }) {
        my @groups = @{ $args->{optgroup} };
        my @ranges = Spreadsheet::HTML::_range( 0, $#$options, $#groups );
        splice( @$options, $_, 0, { tag => 'optgroup', attr => { label => pop @groups } } ) for reverse @ranges;
    }

    $HTML::AutoTag::ENCODE  = defined $args->{encode}  ? $args->{encode}  : exists $args->{encodes};
    $HTML::AutoTag::ENCODES = defined $args->{encodes} ? $args->{encodes} : '';
    return _label( %$args ) . $args->{_auto}->tag(
        tag   => 'select', 
        attr  => $args->{select},
        cdata => [ ( $placeholder || () ), @$options ],
    );
}

sub _label {
    my %args  = @_;
    my $label = {};

    if (ref($args{label}) eq 'HASH') {
        (my $cdata) = keys %{ $args{label} };
        (my $attr)  = values %{ $args{label} };
        $label = { tag => 'label', attr => $attr, cdata => $cdata };
    } elsif (defined $args{label} ) {
        $label = { tag => 'label', cdata => $args{label} };
    } 
    
    return %$label ? $args{_auto}->tag( %$label ) : '';
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

=item * C<list()>

Renders ordered <ol> and unordered <ul> lists.

=back

=head2 LITERAL PARAMETERS

=over 8

=item C<ordered>

Uses <ol> instead of <ul> container when true.

=item C<col>

Emit this column. Default 0. (Zero index based.)
If neither C<col> nor C<row> are specified then the first column is used.

=item C<row>

Emit this row. Default 0. (Zero index based.)
If neither C<col> nor C<row> are specified then the first column is used.

=back

=head2 TAG PARAMETERS

=over 8

=item C<ol>

Hash reference of attributes.

=item C<ul>

Hash reference of attributes.

=item C<li>

Accepts hash reference, sub reference, or array ref containing either or both.

=back

=over 4

=item * C<select()>

Renders <select> lists.

=back

=head2 LITERAL PARAMETERS

=over 8

=item C<col>

Emit this column as the texts (always) and the next column as the values (if C<labels> is true).
Default 0. (Zero index based.) If neither C<row> nor C<col> is specified, then the first row
is used to create the <select> list.

=item C<row>

Emit this row as the texts (always) and the next row as the values (if C<labels> is true).
Default 0. (Zero index based.)

=item C<labels>

Optional boolean. Uses either the next row or column as the values for the text arguments.

=item C<texts>

Optional array ref of default texts to be initially selected.

=item C<values>

Optional array ref of default values to be initially selected.

=item C<placeholder>

Optional string. Inserts the C<placeholder> as the first <option> in the <select> list.
This <option> will always have a value attribute set to empty string regardless of the
value of C<labels>.

=item C<label>

Emits <label> tag for list.

=back

=head2 TAG PARAMETERS

=over 8

=item C<select>

Hash reference of attributes.

=back

=head1 SEE ALSO

=over 4

=item L<Spreadsheet::HTML>

The interface for this functionality.

=item L<Spreadsheet::HTML::Presets>

More presets.

=item L<http://www.w3.org/TR/html5/forms.html#the-select-element>

=item L<http://www.w3.org/TR/html5/forms.html#the-option-element>

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
