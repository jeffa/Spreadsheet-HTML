package Spreadsheet::HTML;
use strict;
use warnings FATAL => 'all';
our $VERSION = '0.07';

use Math::Matrix;
use HTML::Element;

sub new {
    my $class = shift;
    my %attrs = ref($_[0]) eq 'HASH' ? %{+shift} : @_;
    return bless { %attrs }, $class;
}

sub generate    { _wrapper( sub { @_ }, @_ ) }
sub transpose   { _wrapper( sub { @{ Math::Matrix::transpose( [@_] ) } }, @_ ) }
sub reverse     { _wrapper( sub { reverse @_ }, @_ ) }
sub portrait    { generate( @_ ) }
sub landscape   { transpose( @_ ) }

sub _wrapper {
    my $sub   = shift;
    my $self  = shift if UNIVERSAL::isa( $_[0], __PACKAGE__ );
    my $attrs = ref($_[0]) eq 'HASH' ? shift : $self ? {%$self} : {};

    if (@_ > 1 && defined($_[0]) && !ref($_[0]) ) {
        my %args = @_;
        @_ = delete $args{data};
        $attrs = {%args};    
    }

    my @data  = $self ? $self->process_data( @_ ) : process_data( @_ );
    return _make_table( $attrs, $sub->( @data ) );
}

sub process_data {
    my ($self, @data);

	if (UNIVERSAL::isa( $_[0], __PACKAGE__ )) {
        $self = shift;
        return @{ $self->{data} } if exists $self->{__processed_data__};
        $self->{table_attrs} = shift if ref($_[0]) eq 'HASH';
        @_ = $self->{data};
    }

    @data = @_ > 1 ? @_ : @{ ref($_[0]) ? $_[0] : [ $_[0] ] };
    @data = [ @data ] unless ref( $data[0] ) eq 'ARRAY';
    @data = [ undef ] unless @{ $data[0] };

    $self->{data} = _process( @data );
    $self->{data} = _mark_headings( $self->{data} );
    $self->{__processed_data__} = 1;
    return @{ $self->{data} };
}

sub _make_table {
    my $attrs = ref($_[0]) eq 'HASH' ? shift : {};
    $attrs->{$_} ||= {} for qw( table tr th td );

    my $indent  = delete $attrs->{indent};
    my $no_th   = delete $attrs->{matrix};
    my $encodes = '';
    $encodes = delete $attrs->{encodes} if exists $attrs->{encodes};

    my $table = HTML::Element->new_from_lol(
        [table => $attrs->{table},
            map [tr => $attrs->{tr},
                map ref($_) 
                    ? $no_th
                        ? [ td => $attrs->{td}, @$_ ]
                        : [ th => $attrs->{th}, @$_ ]
                    : [ td => $attrs->{td}, $_ ], @$_
            ], @_
        ],
    );

    chomp( my $html = $table->as_HTML( $encodes, $indent ) );
    return $html;
}

# just a way to seperate th cells from td cells now (for later)
sub _mark_headings {
    my $data = shift;
    $data->[0] = [ map [$_], @{ $data->[0] } ];
    return $data;
}


sub _process {
    my @data = @_;

    # padding is determined by first row (the headings)
    my $max_cols = scalar @{ $data[0] };
    for my $row (@data[1 .. $#data]) {
        push @$row, undef for 1 .. ($max_cols - scalar @$row);
    }

    return [
        map { [
            map {
                do { no warnings; s/^\s*$/&nbsp;/g };
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

This is an ALPHA release.

=head1 REQUIRES

=over 4

=item HTML::Entities

Used to encode values with HTML entities.

=item Math::Matrix

Used to transpose data from portrait to landscape.

=back

=head1 SYNOPSIS

    use Spreadsheet::HTML;

    my $data = [
        [qw(header1 header2 header3)],
        [qw(foo bar baz)],
        [qw(one two three)],
        [qw(col1 col2 col3)],
    ];

    my $table = Spreadsheet::HTML->new( data => $data );
    print $table->generate;
    print $table->transpose;
    print $table->reverse;

    print Spreadsheet::HTML::generate( $data );
    print Spreadsheet::HTML::transpose( $data );
    print Spreadsheet::HTML::reverse( $data );

=head1 METHODS

=over 4

=item new()

  my $table = Spreadsheet::HTML->new;
  my $table = Spreadsheet::HTML->new( @data );
  my $table = Spreadsheet::HTML->new( $data );
  my $table = Spreadsheet::HTML->new( data => $data );

Constructs object. Currently accepts one parameter: data.
Data should be a two dimensional array and you should 
expect the first row to be treated as the header (which
means each cell will be wrapped with <th> tags instead 
of <td> tags).

=item generate()

=item portrait()

  my $html = $table->generate;
  my $html = $table->generate( indent => '    ' );
  my $html = $table->generate( encode => '<>&=' );
  my $html = $table->generate( table => { class => 'foo' } );

  my $html = Spreadsheet::HTML::generate( @data );
  my $html = Spreadsheet::HTML::generate( $data );
  my $html = Spreadsheet::HTML::generate(
      data   => $data,
      indent => '    ',
      encode => '<>&=',
      table  => { class => 'foo' },
  );

Returns a string that contains the rendered HTML table.
Currently (and subject to change if better ideas arise),
all data will:

=over 8

=item - be converted to &nbsp; if empty

=item - have any newlines converted to <br> tags

=back

=item transpose()

=item landscape()

  (same usage as generate)    

Uses Math::Matrix to rotate the data 90 degrees and
then returns a string containing the rendered HTML table.

=item reverse()

  (same usage as generate)    

Uses Math::Matrix to rotate the data 180 degrees and
then returns a string containing the rendered HTML table.

=item process_data()

Returns the munged data before it is used to generate
a rendered HTML table. This is called on your behalf, but
is available should you want it.

=back

=head1 ATTRIBUTES

All methods/procedures can accept named arguments.
If named arguments are detected, the data has to be
an array ref assigned to the key 'data'.

=over 4

=item * data => [ [], [], [], ... ]

The data to be rendered into table cells.

=item * indent => 0 or 1

Render the table with whitespace indention. Defaults to
undefined which produces no trailing whitespace to tags.
Useful values are some number of spaces or tabs.
See L<HTML::Element::as_HTML()>

=item * encode => undef, '', or 'chars in a string'

HTML Encode contents of td tags. Defaults to empty string
which performs no encoding of entities. Pass a string like
'<>&=' to perform encoding on any characters found. If the
value is 'undef' then all unsafe characters will be
encoded as HTML entites.
See L<HTML::Element::as_HTML()>

=item * matrix => 0 or 1

Render the table with only td tags, no th tags.

=item * table => { key => 'value' }

=item * tr => { key => 'value' }

=item * th => { key => 'value' }

=item * td => { key => 'value' }

Supply attributes to the HTML tags that compose the table.
There is currently no support for col, colgroup, caption,
thead and tbody. See L<DBIx::XHTML_Table> for that, which
despite being a DBI extension, can accept an AoA and produce
an table with those tags, plus totals and subtotals. That
module cannot produce a transposed table, however.

=back

=head1 REQUIRES

=over 4

=item L<HTML::Tree>

Used to generate HTML.

=item L<Math::Matrix>

Used for transposing data.

=back

=head1 AUTHOR

Jeff Anderson, C<< <jeffa at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to either

=over 4

=item * C<bug-spreadsheet-html at rt.cpan.org>

  Send an email.

=item * L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Spreadsheet-HTML>

  Use the web interface.

=back

I will be notified, and then you'll automatically be notified of progress
on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Spreadsheet::HTML

The Github project is L<https://github.com/jeffa/Spreadsheet-HTML>

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
