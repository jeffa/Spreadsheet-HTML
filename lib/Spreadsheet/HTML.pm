package Spreadsheet::HTML;
use strict;
use warnings FATAL => 'all';
our $VERSION = '0.13';

use Clone;
use HTML::Element;
use Math::Matrix;

use Spreadsheet::HTML::CSV;
use Spreadsheet::HTML::XLS;
use Spreadsheet::HTML::HTML;
use Spreadsheet::HTML::JSON;
use Spreadsheet::HTML::YAML;

sub portrait    { generate( @_ ) }
sub generate    { _make_table( process( @_ ) ) }

sub landscape   { transpose( @_ ) }
sub transpose   {
    my %args = process( @_ );
    $args{data} = [@{ Math::Matrix::transpose( $args{data} ) }];
    return _make_table( %args, tgroups => 0 );
}

sub flip   {
    my %args = process( @_ );
    $args{data} = [ CORE::reverse @{ $args{data} } ];
    return _make_table( %args, tgroups => 0 );
}

sub mirror   {
    my %args = process( @_ );
    $args{data} = [ map [ CORE::reverse @$_ ], @{ $args{data} } ];
    return _make_table( %args );
}

sub reverse   {
    my %args = process( @_ );
    $args{data} = [ map [ CORE::reverse @$_ ], CORE::reverse @{ $args{data} } ];
    return _make_table( %args, tgroups => 0 );
}

sub process {
    my ($self,$data,$args) = _args( @_ );

    if ($self and $self->{is_cached}) {
        return wantarray ? ( data => $self->{data}, %{ $args || {} } ) : $data;
    }

    my $empty = exists $args->{empty} ? $args->{empty} : '&nbsp;';
    my $max_cols = scalar @{ $data->[0] };

    if ($args->{layout}) {
        $args->{encodes} = undef unless exists $args->{encodes}; 
        $args->{matrix} = 1 unless exists $args->{matrix};
        unless (exists $args->{table}) {
            $args->{table}{role}          = 'presentation';
            $args->{table}{border}        = 0;
            $args->{table}{cellspacing}   = 0;
            $args->{table}{cellpadding}   = 0;
        }
    }

    for my $row (0 .. $#$data) {

        unless ($args->{layout}) {
            push @{ $data->[$row] }, undef for 1 .. $max_cols - $#{ $data->[$row] } + 1;  # pad
            pop  @{ $data->[$row] } for $max_cols .. $#{ $data->[$row] };                 # truncate
        }

        for my $col (0 .. $#{ $data->[$row] }) {
            my $tag = (!$row and !($args->{headless} or $args->{matrix})) ? 'th' : 'td';
            my $val = $data->[$row][$col];

            # --empty
            do{ no warnings; $val =~ s/^\s*$/$empty/g };

            # --headings
            $val = $args->{headings}->($val) if !$row and ref($args->{headings}) eq 'CODE';

            $data->[$row][$col] = _element( $tag => $val, $args->{$tag} );
        }
    }

    if ($args->{cache} and $self and !$self->{is_cached}) {
        $self->{data} = $data;
        $self->{is_cached} = 1;
    }

    shift @$data if $args->{headless};

    return wantarray ? ( data => $data, %$args ) : $data;
}

sub new {
    my $class = shift;
    my %attrs = ref($_[0]) eq 'HASH' ? %{+shift} : @_;
    return bless { %attrs }, $class;
}

sub _make_table {
    my %args = @_;
    $args{$_} ||= {} for qw( table tr thead tbody tfoot );

    my $encodes = exists $args{encodes} ? $args{encodes} : '';

    if ($args{tgroups}) {
        if (scalar @{ $args{data} } > 2) {
            # replace last row between 1st and 2nd rows
            splice @{ $args{data} }, 1, 0, pop @{ $args{data} };
        } else {
            delete $args{tgroups};
        }
    }

    # yes, foot is second and not last
    my ($head, $foot, @body) = @{ $args{data} };

    my $head_row  = [tr => $args{tr}, @$head];
    my $foot_row  = [tr => $args{tr}, @{ $foot || [] }];
    my @body_rows = map [tr => $args{tr}, @$_ ], @body;

    my $table = HTML::Element->new_from_lol(
        [table => $args{table},
            ( $args{caption} ? [caption => {}, $args{caption}] : () ),
            ( $args{tgroups} ? [ thead => $args{thead}, $head_row ]  : $head_row ),
            ( $args{tgroups} ? [ tfoot => $args{tfoot}, $foot_row ]  : $foot ? $foot_row : () ),
              $args{tgroups} ? [ tbody => $args{tbody}, @body_rows ] : @body_rows
        ],
    );

    chomp( my $html = $table->as_HTML( $encodes, $args{indent} ) );
    return $html;
}

sub _element {
    my ($tag, $content, $attr) = @_;
    my $e = HTML::Element->new( $tag, %{ $attr || {} } );
    $e->push_content( $content );
    return $e;
}

sub _args {
    my ($self,$data,$args);
    $self = shift if UNIVERSAL::isa( $_[0], __PACKAGE__ );

    if (@_ > 1 && defined($_[0]) && !ref($_[0]) ) {
        $args = {@_};
        $data = delete $args->{data} if exists $args->{data};
    } elsif (@_ > 1 && ref($_[0]) eq 'ARRAY') {
        $data = [ @_ ];
    } elsif (@_ == 1) {
        $data = $_[0];
    }

    if ($self) {
        return ( $self, $self->{data}, $args ) if $self->{is_cached};
        $args = { %{ $self || {} }, %{ $args || {} } };
        delete $args->{data};
        $data = $self->{data} unless $data or $args->{file};
    }

    $data = _load_file( $args->{file} ) if $args->{file};
    $data = [ $data ] unless ref($data);
    $data = [ $data ] unless ref($data->[0]);
    $data = [ [undef] ] if !scalar @{ $data->[0] };

    return ( $self, Clone::clone($data), $args );
}

sub _load_file {
    my $file = shift;

    if ($file =~ /\.csv$/) {
        return Spreadsheet::HTML::CSV::load( $file );
    } elsif ($file =~ /\.html?$/) {
        return Spreadsheet::HTML::HTML::load( $file );
    } elsif ($file =~ /\.jso?n$/) {
        return Spreadsheet::HTML::JSON::load( $file );
    } elsif ($file =~ /\.ya?ml$/) {
        return Spreadsheet::HTML::YAML::load( $file );
    } elsif ($file =~ /\.xls$/) {
        return Spreadsheet::HTML::XLS::load( $file );
    }
}

1;

__END__
=head1 NAME

Spreadsheet::HTML - Render HTML tables with ease.

=head1 SYNOPSIS

    use Spreadsheet::HTML;

    $data = [ [qw(a1 a2 a3)], [qw(b1 b2 b3)], [qw(c1 c2 c3)] ];

    $table = Spreadsheet::HTML->new( data => $data, indent => "\t" );
    print $table->portrait;
    print $table->landscape;

    # non OO
    print Spreadsheet::HTML::portrait( $data );
    print Spreadsheet::HTML::landscape( $data );

    # load from files (first table found)
    $table = Spreadsheet::HTML->new( file => 'data.xls', cache => 1 );

=head1 METHODS

=over 4

=item * C<new( %args )>

  my $table = Spreadsheet::HTML->new( data => $data );

Constructs object. Accepts named arguments (see ATTRIBUTES).
Unless you give it an array of array refs. Or an array ref
of array refs. Otherwise it expects named arguments. The
most favorite being 'data' which is exactly an array ref
of array refs. The first row will be treated as the headings
unless you specify otherwise (see ATTRIBUTES).

=item * C<generate( %args )>

  $html = $table->generate( table => {border => 1}, encode => '<>' );
  print Spreadsheet::HTML::generate( data => $data, indent => "\t" );

Returns a string that contains the rendered HTML table.

=item * C<portrait( %args )>

Alias for C<generate()>

=item * C<transpose( %args )>

Uses Math::Matrix to rotate the headings and data
90 degrees counter-clockwise.

=item * C<landscape( %args )>

Alias for C<transpose()>

=item * C<flip( %args )>

Flips the headings and data upside down.

=item * C<mirror( %args )>

Columns are rendered right to left.

=item * C<reverse( %args )>

Combines flip and mirror: flips the headings and
data upside down and render columns right to left.

=item * C<process( %args )>

Returns processed data.

=back

=head1 ATTRIBUTES

All methods/procedures accept named arguments.
If named arguments are detected: the data has to be
an array ref assigned to the key 'data'. If no
named args are detected then the parameter list is
treated as the data itself, either an array containing
array references or an array reference containing
array references.

=over 4

=item * C<data: [ [], [], [], ... ]>

The data to be rendered into table cells.

=item * C<file: $str>

The name of the data file to read. Supported formats
are XLS, CSV, JSON, YAML and HTML (first table found).

=item * C<indent: $str>

Render the table with whitespace indention. Defaults to
undefined which produces no trailing whitespace to tags.
Useful values are some number of spaces or tabs.  (see
L<HTML::Element>::as_HTML).

=item * C<encode: $str>

HTML Encode contents of td tags. Defaults to empty string
which performs no encoding of entities. Pass a string like
'<>&=' to perform encoding on any characters found. If the
value is 'undef' then all unsafe characters will be
encoded as HTML entites (see L<HTML::Element>::as_HTML).

=item * C<empty: $str>

Replace empty cells with this value. Defaults to &nbsp;
Set value to undef to avoid any substitutions.

=item * C<cache: 0 or 1>

Preserve data after it has been processed (and loaded).

=item * C<matrix: 0 or 1>

Render the table with only td tags, no th tags, if true.

=item * C<layout: 0 or 1>

Add W3C recommended table attributes, emit only <td> tags,
no row padding or pruning, and force no HTML entity encoding
in table cells.

=item * C<headless: 0 or 1>

Render the table with without headings, if true.

=item * C<headings: sub { return function( shift ) }>

Apply this anonymous subroutine to headers.

=item * C<tgroups: 0 or 1>

Group table rows into <thead> <tfoot> and <tbody>
sections. The <tfoot> section is always found before
the <tbody> section. Only available for C<generate()>,
C<portrait()> and C<mirror()>.

=item * C<table: \%args>

=item * C<caption: $str>

=item * C<thead: \%args>

=item * C<tfoot: \%args>

=item * C<tbody: \%args>

=item * C<tr: \%args>

=item * C<th: \%args>

=item * C<td: \%args>

Supply attributes to the HTML tags that compose the table.
There is currently no support for col and colgroup.

=back

=head1 REQUIRES

=over 4

=item * L<HTML::Tree>

Used to generate HTML. Handles indentation and HTML entity encoding.

=item * L<Math::Matrix>

Used for transposing data from portrait to landscape.

=item * L<Clone>

Useful for preventing data from being clobbered.

=back

=head1 OPTIONAL

Used to load data from various different file formats.

=over 4

=item * L<JSON>

=item * L<YAML>

=item * L<Text::CSV>

=item * L<Text::CSV_XS>

=item * L<HTML::TableExtract>

=item * L<Spreadsheet::ParseExcel>

=back

=head1 SEE ALSO

=over 4

=item * L<DBIx::HTML>

Uses this module (Spreadsheet::HTML) to format SQL query results.

=item * L<DBIx::XHTML_Table>

The original since 2001. Can handle advanced grouping, individual cell
value contol, rotating attributes and totals/subtotals.

=back

=head1 REFERENCE

=over 4

=item * L<http://www.w3.org/TR/html5/tabular-data.html>

=back

=head1 THIS IS AN ALPHA RELEASE.

Left TODO before considerd BETA:

=over 4

=item * emit col and colgroup tags by rows

=item * map client functions to cells by columns

=item * assign attrs to td tags by columns, etc.

=item * do that nifty rotating attr value trick

=back

You are encouraged to L<DBIx::XHTML_Table> during the development of this module.

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

=head1 GITHUB

The Github project is L<https://github.com/jeffa/Spreadsheet-HTML>

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

Thank you very much! :)

=over 4

=item * Neil Bowers

Helped with Makefile.PL suggestions and corrections.

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
