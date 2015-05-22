package Spreadsheet::HTML;
use strict;
use warnings FATAL => 'all';
our $VERSION = '0.08';

use HTML::Element;
use Math::Matrix;

use Spreadsheet::HTML::CSV;
use Spreadsheet::HTML::HTML;

sub portrait    { generate( @_ ) }
sub generate    { _make_table( process( @_ ) ) }

sub landscape   { transpose( @_ ) }
sub transpose   {
    my %args = process( @_ );
    $args{data} = [@{ Math::Matrix::transpose( $args{data} ) }];
    return _make_table( %args );
}

sub reverse   {
    my %args = process( @_ );
    $args{data} = [ CORE::reverse @{ $args{data} } ];
    return _make_table( %args );
}


sub process {
    my ($self,$data,$args) = _args( @_ );

    my $max_cols = scalar @{ $data->[0] };
    shift @$data if $args->{headless};

    for my $row (@$data) {
        push @$row, undef for 1 .. ($max_cols - scalar @$row);
        #truncate rows that are too long
        $row = [ @$row[0 .. $max_cols - 1] ] if scalar( @$row ) > $max_cols;

        # white space transliteration
        for my $i (0 .. $#$row) {
            #TODO: this needs to be configurable
            do{ no warnings; $row->[$i] =~ s/^\s*$/&nbsp;/g };
            $row->[$i] =~ s/\n/<br \/>/g;
        }
    }

    unless ( $args->{headless} or $args->{matrix} or ref($data->[0][0]) ) {
        #TODO: make objects here, assign class attrs here
        $data->[0] = [ map [$_], @{ $data->[0] } ];
    }

    return wantarray ? ( data => $data, %$args ) : $data;
}

sub _make_table {
    my %args = @_;
    $args{$_} ||= {} for qw( table tr th td );

    my $indent  = $args{indent};
    my $no_th   = $args{matrix};
    my $encodes = exists $args{encodes} ? $args{encodes} : '';

    my $table = HTML::Element->new_from_lol(
        [table => $args{table},
            map [tr => $args{tr},
                map ref($_)
                    ? $no_th
                        ? [ td => $args{td}, @$_ ]
                        : [ th => $args{th}, @$_ ]
                    : [ td => $args{td}, $_ ], @$_
            ], @{ $args{data} }
        ],
    );

    chomp( my $html = $table->as_HTML( $encodes, $indent ) );
    return $html;
}

sub new {
    my $class = shift;
    my %attrs = ref($_[0]) eq 'HASH' ? %{+shift} : @_;
    return bless { %attrs }, $class;
}

sub _args {
    my ($self,$data,$args);
    $self = shift if UNIVERSAL::isa( $_[0], __PACKAGE__ );

    if (@_ > 1 && defined($_[0]) && !ref($_[0]) ) {
        my %args = @_;
        if (my $arg = delete $args{data}) {
            $data = $arg;
        }
        $args = {%args};
    } elsif (@_ > 1 && ref($_[0]) eq 'ARRAY') {
        $data = [ @_ ];
    } elsif (@_ == 1) {
        $data = $_[0];
    }

    if ($self) {
        $args = { %$self, %{ $args || {} } };
        delete $args->{data};
    }

    unless (exists $args->{file}) {
        if ($self and !$data) {
            $data = $self->{data};
        }

        $data = [ $data ] unless ref($data);
        $data = [ $data ] unless ref($data->[0]);
        $data = [ [undef] ] if !scalar @{ $data->[0] };
    }
    if (my $file = $args->{file}) {
        if ($file =~ /\.csv$/) {
            $data = Spreadsheet::HTML::CSV::load( $file );
        } elsif ($file =~ /\.html?$/) {
            $data = Spreadsheet::HTML::HTML::load( $file );
        }
    }

    if ($self) {
        $self->{data} = $data if delete $args->{cache};
    }

    return ( $self, $data, $args );
}

1;

__END__
=head1 NAME

Spreadsheet::HTML - Tabular data to HTML tables.

=head1 THIS IS AN ALPHA RELEASE.

While most functionality for this module has been completed,
that final 10% takes 90% of the time ... there is still much
todo:

=over 4

=item * emit col, colgroup, thead, tbody and caption tags

=item * map client functions to cells

=item * assign attrs to td tags by row

=item * do that nifty rotating attr value trick

=back

You are encouraged to try my older L<DBIx::XHTML_Table> during
the development of this module.

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

    # non OO
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

=item process()

Data structure that can be used by the following:

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

=item * indent => $str

Render the table with whitespace indention. Defaults to
undefined which produces no trailing whitespace to tags.
Useful values are some number of spaces or tabs.  (see
HTML::Element::as_HTML).

=item * encode => $str

HTML Encode contents of td tags. Defaults to empty string
which performs no encoding of entities. Pass a string like
'<>&=' to perform encoding on any characters found. If the
value is 'undef' then all unsafe characters will be
encoded as HTML entites (see HTML::Element::as_HTML).

=item * matrix => 0 or 1

Render the table with only td tags, no th tags, if true.

=item * headless => 0 or 1

Render the table with without headings, if true.

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

Thank you very much! :)

=over 4

=item * Neil Bowers

Helped with Makefile.PL suggestions and corrections.

=back

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
